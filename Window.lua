print("Loading Window... ")

Window = {}
Window.mon = nil

function Window:new(side)
	if peripheral.isPresent(side) and (peripheral.getType(side) == "monitor") then
		local o = {}
		setmetatable(o, self)
		self.__index = self
		self.mon = peripheral.wrap(side)
		return o
	else
		return nil
	end
end

function Window:reset()
	self.mon.clear()
	self.mon.setCursorPos(1,1)
end

function Window:garble()
	self.mon.write("#########")
end

function Window:test(string)
	self.mon.write(string)
end

print("Finished Window load.")
