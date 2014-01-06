dofile("Bluenet.lua")
redstone.setOutput("top", false)
manager = 51


function run()
	init()
	print("Ready to go.")

	while true do
		sleep(0)
		ret = Bluenet:get(manager)
		if ret then
			if ret == "shutdown" then
				break

			elseif ret == "break" then
				print("Breaking well...")
				break_well()
				Bluenet:respond("move_ready", manager, "ack")
				print("Waiting for place command...")
				Bluenet:get(manager, "place")
				print("Placing well...")
				place_well()
				Bluenet:respond("placed", manager, "ack")
			end

		else
			break
		end

	end

	print("Done mining!")
end

function break_well()
	turtle.select(1)
	if not turtle.transferTo(2,64) then
		if not turtle.getItemCount(2) > 1 then
			panic()
		else
			turtle.drop()
		end
	end
	sleep(1)
	while turtle.getItemCount(1) > 0 do
		turtle.drop()
		sleep(1)
	end
	turtle.dig()
end


function signal_manager(message)
	print("Signaling manager: "..message..".")
	Bluenet:ping_ack(message , manager, "ack", 2)
	print(" -Recieved ack.")
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
				sleep(0)
				turtle.select(1)
				turtle.drop()
				turtle.select(2)
			end
		else
			panic()
		end

	elseif not turtle.detect() then

		print(" -Placing my well.")
		place_well()

	end
	signal_manager("ready")


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
	redstone.setOutput("top", true)
	error("AHHHHHHHHHHHHHHHH")
end

run()
