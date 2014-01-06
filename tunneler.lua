function forward(n)
	for i=1,n do
		turtle.dig()
		ret = turtle.forward()

		if not ret then
			while not ret do
				sleep(0)
				turtle.dig()
				ret = turtle.forward()
			end
		end
	end
end

function refuel()
	for i=2,16 do
		turtle.select(i)
		turtle.refuel(64)
	end
end

function turn()
	turtle.digUp()
	ret = turtle.up()
	if not ret then
		while not ret do
			sleep(0)
			turtle.digUp()
			ret = turtle.up()
		end
	end

	turtle.turnLeft()
	turtle.turnLeft()
end

function clear()
	turtle.placeUp()
	for i=1,16 do
		turtle.select(i)
		turtle.dropUp()
	end
	turtle.select(1)
	turtle.digUp()
end

function layer()
	turtle.select(1)
	turtle.dig()
	turtle.forward()
	turtle.turnRight()

	forward(12)
	turn()

	forward(12)
	turn()

	forward(12)
	turn()

	forward(11)
	turtle.dig()
	turn()

	forward(9)
	turtle.dig()
	turn()

	forward(7)
	turtle.dig()
	turn()

	forward(5)
	turtle.dig()
	turn()

	forward(4)

	for i=1,7 do
		turtle.digDown()
		turtle.down()
	end

	forward(4)
	turtle.turnRight()

	while turtle.detectUp() do
		turtle.digUp()
		sleep(2)
	end

	clear()

end

print("Refueling...")
refuel()

local tArgs = { ... }
if tArgs[1] then
	num = tonumber(tArgs[1])
else
	num = 1
end

if turtle.getFuelLevel() < 110*num then
	print("This mortal form grows weak. I require sustenance!")
	return
end


print("Running "..num.." layers.")

for i=1,num do
	layer()
end

print("Finished!")
