dofile("Bluenet.lua")

redstone.setOutput("right", false)

miners = { 50, 54, 55, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73 }
status = {}
for i=1,table.getn(miners) do
	status[i] = false
end

wait_time = 24

function run()
	print("Waiting for turtles...")
	init()
	print("Ready for mining.")
	while true do
		sleep(0)
		print("Telling turtles to prepare.")
		safe_broadcast("break", "move_ready", miners, "ack", 3)
		print("All turtles ready for move.")
		move()
		while redstone.getInput("back") do
			sleep(0)
			sleep(2)
		end
		print("Telling turtles to place.")
		safe_broadcast("place", "placed", miners, "ack", 3)
		print("All turtles placed!")
		sleep(wait_time)
	end
end

function move()
	redstone.setOutput("right", true)
	sleep(0.4)
	redstone.setOutput("right", false)
	sleep(0.6)
end

function init()

	local id
	while not check_status() do
		sleep(0)
		id = Bluenet:get(nil, "ready")
		print(" -Recieved ready from: "..id)
		for i=1,table.getn(miners) do
			if id == miners[i] then
				Bluenet:send(id, "ack")
				status[i] = true
				print(" -Turtle "..i.." ready.")
				break
			end
		end
	end
end

function check_status()
	for i=1,table.getn(status) do
		if not status[i] then
			return false
		end
	end
	return true
end

run()
