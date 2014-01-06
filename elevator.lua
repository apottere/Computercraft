redstone.setOutput("left", false)
redstone.setOutput("right", false)
redstone.setOutput("back", false)
redstone.setOutput("front", false)
redstone.setOutput("top", false)
redstone.setOutput("bottom", false)

rednet.open("right")

floors = { 45 }
online = { false }
location = -1



function run()

	print("Waiting for floors...")
	init_floors()

	print("Finding state...")
	find_state()

	print("My state is "..location..".")
	sleep(1)

	print("Informing floors...")
	for i=1,table.getn(floors) do
		if i == location then
			rednet.send(floors[i], "open")
		else
			rednet.send(floors[i], "clear")
		end
	end

	for i=1,table.getn(floors) do
		online[i] = false
	end

	print("Everything accounted for.  Ready for operation!")
	sleep(1)

	while true do

		local id,message = rednet.receive()
		action(id, message)

		local id,message = rednet.receive(1.5)
		action(id, message)

		
		--rednet.send(floors[location], "close")
	end

end

function action(id, message)

	if id and message then
		local index = nil
		for i=1,table.getn(floors) do
			if id == floors[i] then
				index = i
				break
			end
		end

		if message == "request" and location ~= index then
			print("Floor "..index.." requested.")
			online[index] = true
			rednet.send(floors[index], "ack")
		end

	end
end

function find_state()
	while not turtle.detect() do
		sleep(0)
		redstone.setOutput("left", true)
		wait(0)
		redstone.setOutput("left", false)
	end

	sleep(1.5)

	for i=1,16 do
		turtle.select(i)
		if turtle.compare() then
			location = i
			break
		end
	end

	if location < 0 then
		error("Strange block detected!")
	end

end

function wait(time)
	sleep(time)
	while not turtle.detect() do
		sleep(0)
	end

end

function init_floors()

	while not check_floors() do
		sleep(0)
		local id, message = rednet.receive()

		if id and message then
			print(" -Message from "..id..": "..message)
			for i=1,table.getn(floors) do
				if id == floors[i] then
					if message == "present" then
						online[i] = true
						print(" -"..id.." online!")
						rednet.send(floors[i], "ack")
					end
				end
			end
		end
	end

end

function check_floors()
	for i=1,table.getn(online) do
		if not online[i] then
			return false

		end
	end
	return true
end


run()
