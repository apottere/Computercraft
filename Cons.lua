print("Loading Cons... ")

Cons = {}

function Cons.fullBuilding(stone, glass, n)
	Cons.buildFrom(stone, glass, 1, n)
end

function Cons.buildFrom(stone, glass, stage, n)
	local l = {}
	while stage <= 8 and stage >= 1 do
		table.insert(l, stage)
		stage = stage + 1
	end

	Cons.parts(stone, glass, l, n)
	
end

function Cons.parts(stone, glass, list, n)

	while table.getn(list) >= 1 do
		local t = list[1]
		table.remove(list, 1)

		if t == 1 then
			Cons.eHallway(stone, glass)

		elseif t == 2 then
			Gassy.go(-8, 8, 0)
			Gassy.turn(0)
			Gassy.push()

		elseif t == 3 then
			Cons.eFloor(20, 20, stone)

		elseif t == 4 then
			Gassy.turnRight()
			Gassy.up()

		elseif t == 5 then
			Cons.eWalls(stone, n)

		elseif t == 6 then
			Gassy.push()
			Cons.eCeiling(stone, glass)

		elseif t == 7 then
			Gassy.go(8, 8, 1)

		elseif t == 8 then
			Cons.eRectangle(4, 4, stone)

		end
	end
end

function Cons.eRectangle(l, w, stone)

	for i=1, 4 do
		if i % 2 == 1 then
			Cons.eLine(l - 1, stone)
		else
			Cons.eLine(w - 1, stone)
		end
		Gassy.forward()
		Gassy.turnRight()
	end
end

function Cons.eCeiling(stone, glass)

	Cons.eBlueprint({
			{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2 }, 
			{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 }
		  }, glass, bricks)

end

function Cons.eBlueprint(schema, ...)
	local tempe = nil
	local num = 0
	local imax = table.getn(schema)
	local jmax = table.getn(schema[1])
	local toggle = true

	for i=1, imax do

		for j=1, jmax do

			if schema[i][j] ~= num then
				num = schema[i][j]
				if num ~= 0 then
					tempe = arg[num]
					tempe.sel(tempe)
				end
			end

			if num ~= 0 then
				tempe.placeDown(tempe)
			end

			if j ~= jmax then
				Gassy.forward()
			end

		end

		if i ~= imax then
			if toggle then
				Gassy.turnRight()
				Gassy.forward()
				Gassy.turnRight()
				toggle = false
			else
				Gassy.turnLeft()
				Gassy.forward()
				Gassy.turnLeft()
				toggle = true
			end
		end
	end
end

function Cons.eWalls(stone, n)
	if n == nil then
		n = 5
	end
	for j=1, 4 do
		for i=1, 4 do
			Cons.eLine(9, stone)
			Gassy.forward(3)
			Cons.eLine(8, stone)
			Gassy.forward()
			Gassy.turnRight()
		end
		Gassy.up()
	end

	for j=1, n - 4 do
		for i=1, 4 do
			Cons.eLine(19, stone)
			Gassy.forward()
			Gassy.turnRight()
		end
		Gassy.up()
	end
end

function Cons.eHallway(stone, glass)

	Cons.eFloor(8, 4, stone)

	Gassy.turnRight()
	Gassy.forward(3)
	Gassy.turnRight()
	Gassy.up()

	local tempe
	for i=1, 5 do
		if i == 1 or i == 5 then
			tempe = stone
		else
			tempe = glass
		end

		Cons.eLine(8, tempe)

		Gassy.turnRight()
		Gassy.forward(3)
		Gassy.turnRight()

		Cons.eLine(8, tempe)

		if i ~= 5 then
			Gassy.turnRight()
			Gassy.forward(3)
			Gassy.turnRight()
			Gassy.up()
		end

	end
	Gassy.turnRight()
	Gassy.forward(2)
	Gassy.turnRight()

	Cons.eFloor(8, 2, glass)
end

function Cons.eFloor(l, w, e)
	local toggle = true
	for i=1, w do
		Cons.eLine(l, e)
		if i ~= w then
			if toggle then
				Gassy.turnRight()
				Gassy.forward()
				Gassy.turnRight()
				toggle = false
			else
				Gassy.turnLeft()
				Gassy.forward()
				Gassy.turnLeft()
				toggle = true
			end
		end
	end
end

function Cons.eLine(l, e)
	e.sel(e)
	for j=1, l do
		e.placeDown(e)
		if j ~= l then
			Gassy.forward()
		end
	end
end

print("Finished Cons load.")
