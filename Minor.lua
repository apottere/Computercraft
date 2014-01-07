print("Loading Minor... ")
Deps.needs("Enderage")
Deps.needs("Gassy")
Deps.needs("Turtles")
Deps.needs("Panic")

Minor = {}
Minor.output = nil
Minor.gas = nil

function Minor:new(output, gas)
	
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.output = output
	o.gas = gas
	Gassy.init(o.gas, false)

	return o
end

function Minor:inventoryItr()
	local gas = self.gas
	local chest = self.output.chest

	return function(_, last)
		local new = last + 1
		while new == gas or new == chest do
			new = new + 1
		end

		if new > 16 then
			return nil
		else
			return new
		end
	end
end


function Minor:mine()
	self:safeMine(Turtles.forward)
end

function Minor:mineDown()
	self:safeMine(Turtles.down)
end

function Minor:mineUp()
	self:safeMine(Turtles.up)
end

function Minor:safeMine(dir)
	if Turtles.detect(dir) then
		self:possibleEmpty()
		return Turtles.move(dir)
	else
		return true
	end
end

function Minor:safeMineMove(dir)
	self:safeMine(dir)
	while not Turtles.move(dir) do
		sleep(0)
		if Turtles.detect(dir) then
			if not self:safeMine(func) then
				Panic.panic("Encountered an unbreakable block!")
			end
		else
			Turtles.attack(dir)
		end
	end
end

function Minor:line(x, dir)
	for i= 1, x do
		self:safeMineMove(dir)
	end
end

function Minor:lineForward(x)
	self:line(x, Turtles.forward)
end

function Minor:lineDown(x)
	self:line(x, Turtles.down)
end

function Minor:square(l, w, mod)
	if not mod == 1 then
		mod = 0
	end

	for i=1, w do
		self:lineForward(l - 1)

		if i < w then
			if i % 2 == mod then
				turnFunc = Gassy.turnLeft
			else
				turnFunc = Gassy.turnRight
			end
			turnFunc()
			self:lineForward(1)
			turnFunc()
		end
	end
end

function Minor:cube(l, w, h)
	local mod = 1

	for i=1, h do

		if mod == 1 then
			mod = 0
		else
			mod = 1
		end

		self:square(l, w, mod)
		if i < h then
			self:lineDown(1)
		end
	end
end

function Minor:possibleEmpty()
	if self:inventoryFull() then
		self:empty()
	end
end

function Minor:empty()
	output:store(self:inventoryItr())
end

function Minor:inventoryFull()
	local empty = false
	for i = 1, 16 do
		if turtle.getItemCount(i) == 0 then
			empty = true
			break
		end
	end
	return not empty
end

print("Finished Minor load.")
