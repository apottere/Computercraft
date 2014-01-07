print("Loading Deps... ")

Deps = {}

function Deps.needs(module)
	if _G[module] == nil then
		Deps.load(module)
	end
end

function Deps.clean()
	if fs.exists("/deps") then
		fs.delete("/deps")
	end
end

function Deps.load(module)
	if not fs.exists("/deps") then
		fs.makeDir("/deps")
	else
		if not fs.isDir("/deps") then
			error("Deps: /deps exists and is not a directory.")
		end
	end

	print("  ->Deps loading " .. module .. "..." )
	local filename = module .. ".lua"
	if not fs.exists('/deps/' .. filename) then
		print("Calling run.")
		shell.run("/get", "file " .. filename .. " /deps")
		print("Called run.")
	end

	if not fs.exists('/deps/' .. filename) then
		error("Deps: Unable to resolve dependencies: " .. filename .. " missing.")
	else
		dofile('/deps/' .. filename)
	end
end

print("Finished Deps load.")
