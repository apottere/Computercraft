write("Loading Minor module... ")

Minor = {}
Minor.output = nil
Minor.gas = nil

function Minor:new(output, gas)
	
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.output = output
	o.gas = gas
	Gassy.init(o.gas)

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
	self:safeMine(turtle.dig)
end

function Minor:mineDown()
	self:safeMine(turtle.digDown)
end

function Minor:mineUp()
	self:safeMine(turtle.digUp)
end

function Minor:safeMine(func)
	self:possibleEmpty()
	func()
end

function Minor:line(x)
	for i= 1, x do
		self:mine()
		while not Gassy.tryForward() do
			self:mine()
		end
	end
end

function Minor:square(l, w)
	for i=1, w do
		self:line(l - 1)

		if i < w then
			if i % 2 == 0 then
				turnFunc = Gassy.turnLeft
			else
				turnFunc = Gassy.turnRight
			end
			turnFunc()
			self:line(1)
			turnFunc()
		end
	end
end

function Minor:cube(l, w, h)
	for i=1, h do
		self:square(l, w)
		Gassy.go_point()
		if i < h then
			self:mineDown()
			Gassy.down()
			Gassy.push()
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

print("Done.")
