print("Loading Bluenet...")

Bluenet = {}

function Bluenet:respond(message, id, rmessage)
	if not message or not rmessage then
		return false
	end

	while true do
		sleep(0)
		ret = Bluenet:get(id, message)
		if ret then
			Bluenet:send(id, rmessage)
			return ret
		end
	end

end

function safe_broadcast(message, cmessage, list, rmessage, timeout)
	if not list then
		return false
	end

	Bluenet:broadcast(message, list)

	for i=1,table.getn(list) do
		Bluenet:ping_ack(cmessage, list[i], rmessage, timeout)
	end
end

function Bluenet:broadcast(message, list)

	if not message then
		return false
	end

	if not list then
		rednet.broadcast(message)
		return true
	end

	for i=1,table.getn(list) do
		Bluenet:send(list[i], message)
	end
end

function Bluenet:get(id, message, timeout)
	local loc_id, loc_message = rednet.receive(timeout)
	if loc_id and loc_message then

		if id and message then
			if loc_id == id and loc_message == message then
				return true
			end
			return false

		elseif id then
			if loc_id == id then
				return loc_message
			end
			return nil

		elseif message then
			if loc_message == message then
				return loc_id
			end
			return nil

		else
			return { loc_id, loc_message }
		end

	end
end

function Bluenet:ping_ack(smessage, id, message, timeout)

	local loc_message = nil
	while true do
		sleep(0)
		Bluenet:send(id, smessage)
		ret = Bluenet:get(id, message, timeout)
		if ret then
			break
		end
	end
end

function Bluenet:send(id, message)
	rednet.send(id, message)
end

function Bluenet:open()

	local sides = {"right", "left", "front", "back", "top", "bottom" }
	local status = false
	local n = nil
	for i=1,table.getn(sides) do
		local ret = pcall(rednet.open, sides[i])
		if ret and rednet.isOpen(sides[i]) then
			status = true
			n = i
			break
		end
	end

	if not status then
		error("Bluenet: No wireless modem!")
	else
		print("Finished Bluenet load. (side: "..sides[n]..")--")
	end

end

Bluenet:open()
