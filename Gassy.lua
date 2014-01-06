write("Loading Gassy module... ")

Gassy = {}
Gassy.ender = nil
Gassy.level = 0
Gassy.waypoints = {{0, 0, 0, 0}}
Gassy.dir = 0
Gassy.x = 0
Gassy.y = 0
Gassy.z = 0


function Gassy.dump()
	print("Gassy stats:")
	print("\tFuel: "..turtle.getFuelLevel().." ("..Gassy.level..")")
	print("\tPos: ("..Gassy.x..", "..Gassy.y..", "..Gassy.z..")")
	print("\tDir: "..Gassy.dir)
	print("\tWaypoints:")
	local max = table.getn(Gassy.waypoints)
	for i=1, max do
		local list = Gassy.waypoints[i]
		print("\t\t("..list[1]..", "..list[2]..", "..list[3]..")")
	end
end

function Gassy.init(num)
	Gassy.ender = Enderage.new(Enderage, num, num)
	Gassy.fuel()
end

function Gassy.fuel()
	if turtle.getFuelLevel() <= 5120 then
		Gassy.ender.prepare(Gassy.ender)

		while turtle.getFuelLevel() <= 5120 do
			sleep(0)
			Gassy.ender.pull(Gassy.ender)
			turtle.refuel()
		end
		Gassy.ender.clean(Gassy.ender)
		print("Gassy: refueled to "..turtle.getFuelLevel())
	end
	Gassy.level = turtle.getFuelLevel()
end

function Gassy.turn(s)
	local diff = (Gassy.dir - s) % 4

	if diff == 0 then
		return
	end

	if diff == 1 then
		turtle.turnLeft()

	elseif diff == 2 then
		turtle.turnLeft()
		turtle.turnLeft()
	
	elseif diff == 3 then
		turtle.turnRight()

	end
	Gassy.dir = s
end

function Gassy.turnRight()
	Gassy.turn((Gassy.dir + 1) % 4)
end

function Gassy.turnLeft()
	Gassy.turn((Gassy.dir - 1) % 4)
end

function Gassy.tryForward()
	return Gassy.forward(1, false)
end

function Gassy.forward(n, panic)
	if n == nil then
		n = 1
	end

	if panic == nil then
		panic = true
	end

	if Gassy.move(turtle.forward, n, panic) then

		if Gassy.dir % 2 == 0 then
			if Gassy.dir == 0 then
				Gassy.y = Gassy.y + n
			else
				Gassy.y = Gassy.y - n
			end
		else
			if Gassy.dir == 1 then
				Gassy.x = Gassy.x + n
			else
				Gassy.x = Gassy.x - n
			end
		end

		return true
	else
		return false
	end
end

function Gassy.up(n)
	if n == nil then
		n = 1
	end

	Gassy.move(turtle.up, n)
	Gassy.z = Gassy.z + n
end

function Gassy.down(n)
	if n == nil then
		n = 1
	end

	Gassy.move(turtle.down, n)
	Gassy.z = Gassy.z - n
end

function Gassy.move(func, n, panic)
	if panic == nil then
		panic = true
	end

	if Gassy.level <= 5120 then
		Gassy.fuel()
	end

	if panic then
		for i=1, n do
			while not func() do
				Panic.panic("Path is blocked!")
			end
			Gassy.level = Gassy.level - 1
		end
	else
		for i=1, n do
			if not func() then
				return false
			end
			Gassy.level = Gassy.level - 1
		end
	end

	return true
end

function Gassy.go(x, y, z)

	print("Going to ("..x..", "..y..", "..z..")")

	if Gassy.x - x > 0 then
		Gassy.turn(3)
		Gassy.forward(Gassy.x - x)
	elseif Gassy.x - x < 0 then
		Gassy.turn(1)
		Gassy.forward(x - Gassy.x)
	end

	if Gassy.y - y > 0 then
		Gassy.turn(2)
		Gassy.forward(Gassy.y - y)
	elseif Gassy.y - y < 0 then
		Gassy.turn(0)
		Gassy.forward(y - Gassy.y)
	end

	if Gassy.z - z > 0 then
		Gassy.down(Gassy.z - z)
	elseif Gassy.z - z < 0 then
		Gassy.up(z - Gassy.z)
	end
end

function Gassy.home()
	while Gassy.pop() do
		sleep(0)
	end
	Gassy.go_point()
end

function Gassy.pop()
	local max = table.getn(Gassy.waypoints)

	if max > 1 then
		local list = Gassy.waypoints[max]
		Gassy.x = Gassy.x + list[1]
		Gassy.y = Gassy.y + list[2]
		Gassy.z = Gassy.z + list[3]
		Gassy.dir = (Gassy.dir + list[4]) % 4
		table.remove(Gassy.waypoints)
		return true
	end
	return false
end

function Gassy.push()
	table.insert(Gassy.waypoints, {Gassy.x, Gassy.y, Gassy.z, Gassy.dir})
	Gassy.x = 0
	Gassy.y = 0
	Gassy.z = 0
	Gassy.dir = 0
end

function Gassy.go_point()
	Gassy.go(0, 0, 0)
	Gassy.turn(0)
end

print("Done.")
