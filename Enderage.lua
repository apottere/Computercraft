print("Loading Enderage... ")
Enderage = {}

Deps.needs("Panic")

Enderage.item = 0
Enderage.chest = 0
Enderage.pullFunc = nil
Enderage.breakFunc = nil
Enderage.dropFunc = nil
Enderage.turns = 0
Enderage.count = 0
Enderage.placeable = true

function Enderage:new(item, chest)
	
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.item = item
	o.chest = chest
	o.count = turtle.getItemCount(item)
	return o
end

function Enderage:newOutput(chest)
	
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.chest = chest
	o.placeable = false
	return o
end

function Enderage:prepare()
	turtle.select(self.chest)
	self.turns = 0
	local ret
	
	if not turtle.detectUp() and turtle.placeUp() then
		self.breakFunc = turtle.digUp
		self.pullFunc = turtle.suckUp
		self.dropFunc = turtle.dropUp
		
	elseif not turtle.detectDown() and turtle.placeDown() then
		self.breakFunc = turtle.digDown
		self.pullFunc = turtle.suckDown
		self.dropFunc = turtle.dropDown

	elseif not turtle.detect() and turtle.place() then
		self.breakFunc = turtle.dig
		self.pullFunc = turtle.suck
		self.dropFunc = turtle.drop

	else
		while true do
			sleep(0)
			if self.turns >= 3 then
				Panic.panic("Enderage: No space to place chest!")
				error("That's really bad, not sure how to recover.")
			end

			turtle.turnRight()
			self.turns = self.turns + 1

			if not turtle.detect() and turtle.place() then
				break
			end
		end
		self.breakFunc = turtle.dig
		self.pullFunc = turtle.suck
		self.dropFunc = turtle.drop
	end
end

function Enderage:pull()

	if self.placeable then
		turtle.select(self.item)
		while not self.pullFunc() do
			Panic.panic("No more items!")
		end
		self.count = turtle.getItemCount(self.item)
	else
		error("Enderage: Called pull() on output ender storage!")
	end
end

function Enderage:clean()

	turtle.select(self.chest)
	while not self.breakFunc() do
		Panic.panic("Could not break chest! (Can I dig?)")
	end
	while self.turns > 0 do
		turtle.turnLeft()
		self.turns = self.turns - 1
	end
end

function Enderage:refill()
	if self.placeable then
		local slot = turtle.getItemCount(self.item)

		if slot ~= 0 then
			self.count = slot

		else
			self:prepare()
			self:pull()
			self:clean()
		end
	else
		error("Enderage: Called refill() on output ender storage!")
	end
end

function Enderage:sel()
	if self.placeable then
		turtle.select(self.item)
	else
		error("Enderage: Called sel() on output ender storage!")
	end
end

function Enderage:safePlace(func)
	if self.placeable then
		if self.count <= 0 then
			self:refill()
			self:sel()
		end

		if not func() and self.count ~= 0 and turtle.getItemCount(self.item) == 0 then
			self:refill()
			func()
		end

		self.count = self.count - 1
	else
		error("Enderage: Called place() on output ender storage.")
	end
end

function Enderage:place()
	self:safePlace(turtle.place)
end

function Enderage:placeUp()
	self:safePlace(turtle.placeUp)
end

function Enderage:placeDown()
	self:safePlace(turtle.placeDown)
end

function Enderage:store(itr)
	self:prepare()
	for k in itr, nil, 0 do
		turtle.select(k)
		self.dropFunc()
	end
	self:clean()
end

print("Finished Enderage load.")
