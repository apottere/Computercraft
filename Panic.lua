print("Loading Panic...")
Panic = {}


function Panic.panic(str)
	print("\n-----------------Help!-----------------")
	print("Error: "..str)
	print("\n[Enter] - resume\n[Backspace] - exit")

	while true do
		sleep(0)
		tp, key = os.pullEvent()

		if tp == "key" then
			
			if key and key == 14 then

				error("Aborted by user.")

			elseif key == 28 then

				print("----------------Resumed----------------")
				break
			end
		end
	end
end

print("Finished Panic load.")
