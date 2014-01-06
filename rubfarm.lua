function empty()
	if turtle.getItemCount(2) > 1 then
		turtle.select(2)
		turtle.drop(turtle.getItemCount(2) - 1)
	end

	for i=4,15 do
		if turtle.getItemCount(i) ~= 0 then
			turtle.select(i)
			turtle.drop()
		end
	end
end

function refuel()
	turtle.select(16)
	if turtle.getFuelLevel() < 5000 then
		turtle.refuel()
	end

	while turtle.getItemCount(16) == 0 do
		print("Refueling: "..turtle.getFuelLevel())
		turtle.suckDown(1)
		if turtle.getFuelLevel() < 5000 then
			turtle.refuel()
		end
		sleep(0)
	end
	turtle.select(1)
end

function restock()
	turtle.select(1)
	if turtle.getItemCount(1) == 0 then
		turtle.turnRight()
		turtle.suck(1)
		turtle.turnLeft()
	end
	
	turtle.select(3)
	if turtle.getItemCount(3) == 0 then
		turtle.turnLeft()
		turtle.suck()
		turtle.turnRight()
	end

end

function replant()
	turtle.select(1)
	turtle.place()
end

function chop()
	local height = 0
	turtle.dig()
	turtle.forward()
	while turtle.compareUp() do
		turtle.digUp()
		turtle.up()
		height = height + 1
		sleep(0)
	end

	for i=1,height do
		turtle.down()
		sleep(0)
	end
	turtle.back()

end

function force()
	print("Forcing tree...")
	turtle.select(3)
	turtle.place()
	turtle.select(2)
end

turtle.select(1)
restock()

while true do
	refuel()
	replant()
	restock()
	turtle.select(2)
--	local timer = 0
	while not turtle.compare() do
		empty()
		turtle.select(2)
		sleep(0)
		sleep(2)
--		timer = timer + 2
--		if timer >= 150 then
--			print("Forcing tree...")
--			force()
--			break
--		end
	end
	chop()
	sleep(10)
end
