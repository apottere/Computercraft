redstone.setOutput("back", true)


function run()
	init()
	print("Ready to go.")
	sleep(5)

	while true do
		sleep(0)

		print("Breaking well...")
		break_well()

		redstone.setOutput("back", false)

		while true do
			sleep(0)
			local event, side = os.pullEvent("redstone")
			if redstone.getInput("top") then
				break
			end
		end

		redstone.setOutput("back", true)

		print("Placing well...")
		place_well()
		sleep(5)

	end

	print("Done mining!")
end

function break_well()
	turtle.select(1)
	if not turtle.transferTo(2,64) then
		if not turtle.getItemCount(2) > 1 then
			panic()
		else
			turtle.dropDown()
		end
	end
	sleep(1)
	while turtle.getItemCount(1) > 0 do
		turtle.dropDown()
		sleep(2)
	end
	turtle.dig()
end


function init()

	print("Getting my bearings...")
	if turtle.getItemCount(1) == 0 then

		print(" -I have an empty slot.")
		turtle.select(2)
		if turtle.compareTo(16) and turtle.getItemCount(2) >= 2 then
			print(" -Fixing empty slot.")
			while not turtle.transferTo(1,1) do
				sleep(0)
				print(" -Cleaning slot 1.")
				turtle.select(1)
				turtle.dropDown()
				turtle.select(2)
			end
		else
			panic()
		end

	elseif not turtle.detect() then

		print(" -Placing my well.")
		place_well()

	end

end



function place_well()
	turtle.select(1)
	turtle.place()
	turtle.select(2)
	if not turtle.transferTo(1,1) then
		print(" -Foreign object found, waiting till pickup to clean.")
	end
end


function panic()
	print("AHHHHHHHHHHHHHHH")
	redstone.setOutput("back", true)
	error("AHHHHHHHHHHHHHHHH")
end

run()
