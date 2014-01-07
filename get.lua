Get = {}

function Get.main(action, name, location)
	hostname="http://modelofnothing.com"
	page="/pastebin"

	local function printUsage()
		print( "Usages:" )
		print( "get [file,proj] <filename>" )
	end

	if action == nil then
		return
	end


	if not http then
		print( "get requires http API" )
		print( "Set enableAPI_http to true in mod_ComputerCraft.cfg" )
		return
	end

	-- Download a file from modelofnothing.no-ip.org
	print()

	if action == "file" then
		-- Determine file to download
		local sFile = name
		local path = location

		if path == nil then
			path = ""
		end

		-- GET the contents from pastebin
		print( "-Get "..hostname.."-" )
		write("\t-Connecting.. ")
		local response = http.get( hostname..page.."?f="..sFile )

		if response then
			local sResponse = response.readAll()

			print("Success.")
			write("\t-Getting \""..sFile.."\".. ")  
			if sResponse and (sResponse ~= "") then  
				print( "Success." )

				response.close()

				local fqp = fs.combine(fs.combine("/", path), sFile)
				write( "\t-Saving as \""..fqp.."\".. " )

				if fs.exists( fqp ) then
					fs.delete( fqp )
				end

				local file = fs.open( fqp, "w" )
				file.write( sResponse )
				file.close()

				print("Success.")
				print()


			else
				error("No file exists.")
			end
		else
			error( "Connection failure." )
			exit(1)
		end
		
	elseif action == "proj" then


		if not fs.exists("/split") then
			print("-Getting get dependencies-")
			ret, err = pcall( Get.main, "file", "/split")

			if not ret then
				error("Unable to get dependency \"split\":\n"..err)
			else
				print()
			end
		end

		dofile("/split")

		-- Determine proj to download
		local sFile = name
		print( "-Get "..hostname.."-" )
		write("\t-Connecting.. ")
		local response = http.get( hostname..page.."?p="..sFile )

		if response then
			local sResponse = response.readAll()
			print("Success.")
			write("\t-Extracting project info.. ")  

			if sResponse and sResponse ~= "" then  
				projArr = split(sResponse, '\n')
				print( "Success." )
				print("\n---Project Contents---")

				local projNum = table.getn(projArr)

				for i=1,projNum do
					print("> "..projArr[i])
				end

				local dir = ""
				if shell then
					dir = shell.dir()
				end

				if not dir or dir == "" then
					dir = "/"
				end
				

				filePath = dir
				write("\nInstall project to \""..filePath.."\"? [Y/n] ")
				input = read()

				if not input 
					or (input == "n")
					or (input == "N")
					or (input == "no")
					or (input == "No")
					or (input == "NO")
					then
					
					print("Installation cancelled by user.")
					return
				end

				print("\n---Downloading files to "..filePath.."---")
				
				for i=1,projNum do
					write("["..i.."/"..projNum.."]")
					ret, err = pcall( Get.main, "file", projArr[i])

					if not ret then
						print("Error: One or more files failed to download:")
						print(err)
						break
					end
				end
			else
				error("No project exists.")
			end
		end
	else
		printUsage()
	end
end

local tArgs = { ... }
Get.main(tArgs[1], tArgs[2], tArgs[3])
