monitor = nil
manager = 49
id = os.getComputerID()
is_open = false


function run()

	init()

	sleep(1)

	while true do
		sleep(0)
		if is_open then
			local message = rednet_get(manager)
			print("Message: "..message)
		else
			while true do
				sleep(0)
				event, x1, x2, x3 = os.pullEvent()
				print("event: "..event)

				if event == "monitor_touch" then
					display_button(colors.red)

					rednet.send(manager, "request")
					while not rednet_get(manager, "ack", 1) do
						sleep(0)
						rednet.send(manager, "request")
					end

					display_button(colors.yellow)

				end
			end
		end
	end
end

function init()

	print("Getting my things together...")
	init_mon()
	close_door()
	sleep(1)

	rednet.open("bottom")

	print("Signalling manager("..manager..")...")
	rednet.send(manager, "present")

	print("Awaiting ack...")
	while not rednet_get(manager, "ack", 2) do
		sleep(0)
		rednet.send(manager, "present")
	end

	print("Awaiting all clear...")
	local message = nil
	while not message do
		message = rednet_get(manager)
		sleep(0)
	end

	if message == "clear" then
		print("Received clear, reacting.")
		display_button(colors.lime)

	elseif message == "open" then
		print("Received open, reacting.")
		display_button(colors.red)
		open_door()
		is_open = true
	end

	print("Ready to roll!")
end

function init_mon()
	monitor = peripheral.wrap("top")

	display_button(colors.red)

end

function rednet_get(id, message, timeout)
	if message then
		local loc_id, loc_message = rednet.receive(timeout)
		if loc_id and loc_message then
			if loc_id == id and loc_message == message then
				return true
			end
		end
		return false
	else
		local loc_id, loc_message = rednet.receive(timeout)
		if loc_id and loc_id == id then
			return loc_message
		end
		return nil
	end
end


function display_button(color)

	monitor.setBackgroundColor(colors.lightGray)
	monitor.clear()

	monitor.setBackgroundColor(color)
	monitor.setCursorPos(1,1)

	draw_points({   "       ",
					" ooooo ",
					" ooooo ",
					" ooooo ",
					"       "
				})


end

function draw_points(points)
	for i=1,table.getn(points) do
		for j=1,string.len(points[i]) do

			local c = string.sub(points[i], j, j)
			if c == "o" then
				monitor.setCursorPos(j,i)
				monitor.write(" ")
			end
		end
	end
end

function open_door()
	redstone.setOutput("front", false)
	sleep(0.3)
	redstone.setOutput("left", false)
end

function close_door()
	redstone.setOutput("left", true)
	sleep(0.3)
	redstone.setOutput("front", true)
end

run()
