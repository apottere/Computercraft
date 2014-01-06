function pistons(open)

	if open then
		redstone.setOutput("bottom", false)
		sleep(time)
		redstone.setOutput("left", false)

	else
		redstone.setOutput("left", true)
		sleep(time)
		redstone.setOutput("bottom", true)

	end
end

flag = false
time = 0.2
falltime = 1
controlid = 96
rednet.open("right")
print("Cycling...")
pistons(true)
sleep(falltime)
pistons(false)
print("Complete.  Ready to serve.")

while true do

	manager, message, dist = rednet.receive()

	if(manager == controlid) then
		number = tonumber(message)
		print("Manager called to open slot "..number..".")
		turtle.select(number)
		turtle.drop()
		pistons(true)
		sleep(falltime)
		pistons(false)
		turtle.suck()
		sleep(0.1)
		rednet.send(controlid, "ready")
	
	else
		print("Hax detected!  ID: "..manager)

	end

end
