print("---Loading Crafty module---")

Crafty = {}
Crafty.table = { nil, nil, nil,
				nil, nil, nil,
				nil, nil, nil
				}

Crafty.trans = { 6, 7, 8,
				10, 11, 12,
				14, 15, 16
				}
				
Crafty.vacant = { 1, 2, 3, 4, 5, 9, 13 } 

Crafty.timeout = nil
Crafty.pos = 0
Crafty.total = 0
Crafty.totalmax = 1000

Crafty.dropSide = nil
Crafty.dropFunc = nil
Crafty.dropTotal = 0
Crafty.dropTotalMax = 100000
Crafty.selected = 1

function Crafty:new( s1, s2, s3, s4, s5, s6, s7, s8, s9, sout, mtimeout)

	local o = {}
	setmetatable(o, self)
	self.__index = self

	

	if mtimeout and mtimeout >= 0 then
		o.timeout = mtimeout
	end

	o:set(s1, 1)
	o:set(s2, 2)
	o:set(s3, 3)
	o:set(s4, 4)
	o:set(s5, 5)
	o:set(s6, 6)
	o:set(s7, 7)
	o:set(s8, 8)
	o:set(s9, 9)

	if sout == "top" then
		o.dropSide = nil
		o.dropFunc = turtle.dropUp
		
	elseif sout == "bottom" then
		o.dropSide = nil
		o.dropFunc = turtle.dropDown
	else
		o.dropFunc = turtle.drop

		if sout == "front" then
			o.dropSide = 0

		elseif sout == "right" then
			o.dropSide = 1

		elseif sout == "back" then
			o.dropSide = 2

		elseif sout == "left" then
			o.dropSide = 3
		end
	end

	return o

end

function Crafty:run()
	print("Initializing...")
	if not self:findAnchor() then
		print("\t\t--Anchor me, silly!")
		return
	end

	self:clean()
	print("Clearing data...")
	self.dropTotal = 0
	print("Ready to craft!")
	
	while true do
		self:replenish()
		self:craft()
		self:clean()
		print()
	end
end

function Crafty:select(n)
	turtle.select(n)
	self.selected = n
end


function Crafty:findAnchor()

	local ret = false
	print("\t-Finding my anchor...")

	redstone.setOutput("front", false)
	redstone.setOutput("right", false)
	redstone.setOutput("back", false)
	redstone.setOutput("left", false)

	sleep(1)
	
	for i=1,4 do
		if redstone.getInput("front") then
			self.pos = 0
			ret = true
			print("\t\t--Found!")
			break
		else
			turtle.turnLeft()
		end
	end
	return ret
end


function Crafty:clean()
	i = 1
	local total = 0
	print("\t-Cleaning inventory...")
	print("\t\t-Pass "..i..":")
	temptotal = self:empty()

	while temptotal ~= 0 do
		i = i + 1
		total = total + temptotal
		print("\t\t-Pass "..i..":")
		temptotal = self:empty()
	end
	
	print("\t\t-Dropped: "..total)

	if (self.dropTotal + total) < self.dropTotalMax then
		self.dropTotal = self.dropTotal + total
		print("Total overall: "..self.dropTotal)
	else
		print("Total overall: "..self.dropTotalMax.."+")
	end
	return total
end


function Crafty:empty()

	local dropped = 0
	for i=1,table.getn(self.vacant) do
		slot = self.vacant[i]

		if turtle.getItemCount(slot) ~= 0 then

			print("\t\t\t-Dropping slot: "..slot)
			self:select(slot)

			if self.dropSide then
				self:turn(self.dropSide)
			end

			dropped = dropped + turtle.getItemCount(slot)

			while turtle.getItemCount(slot) ~= 0 do
				

				if (not self.dropFunc()) and self.timeout then
					sleep(self.timeout)
				end
				sleep(0)
			end

		end
	end
	return dropped
end


function Crafty:helpme()
	print("----------Help!----------")
	print("[Backspace] - exit\n[Enter] - resume")
	local side = nil

	if redstone.getInput("front") then
		side = "front"

	elseif redstone.getInput("right") then
		side = "right"
		
	elseif redstone.getInput("back") then
		side = "back"
		
	elseif redstone.getInput("left") then
		side = "left"
	end	

	if side then
		redstone.setOutput(side, true)
	end

	while true do
		sleep(0)
		tp, key = os.pullEvent()

		if tp == "redstone" then
			if redstone.getOutput(side) then
				redstone.setOutput(side, false)
			else
				redstone.setOutput(side, true)
			end

		elseif tp == "key" then
			
			if key and key == 14 then

				if side then
					redstone.setOutput(side, false)
				end
				error("Aborted by user.")

			elseif key == 28 then
				if side then
					redstone.setOutput(side, false)
				end

				print("----------Resumed!----------")
				break
			end
		end
	end
end


function Crafty:craft()

	print("\t-Craftying...")
	self:select(1)

	if not turtle.craft() then
		self:helpme()
	end

	if self.total < self.totalmax then
		self.total = self.total + 1
		print("\t\t-Craftyed: "..self.total)
	else
		print("\t\t-Craftyed: "..self.totalmax.."+")
	end
end

function Crafty:replenish()
	print("\t-Refilling inventory...")
	for i=1,9 do
		if self.table[i] ~= nil then
			if turtle.getItemCount(self.trans[i]) == 0 then
				print("\t\t-Refilling: "..i.." (slot "..self.trans[i]..")")
				self:select(self.trans[i])
				self.table[i](self)
			end
		end
	end
end

function Crafty:set(side, num)
	if side and (num >= 1) and (num <= 9) then

		local func = nil

		if side == "top" then
			func = self.suckUp

		elseif side == "bottom" then
			func = self.suckDown

		elseif side == "front" then
			func = self.suckFront

		elseif side == "right" then
			func = self.suckRight

		elseif side == "left" then
			func = self.suckLeft

		elseif side == "back" then
			func = self.suckBack

		else
			func = nil

		end
		self.table[num] = func
	end
end

function Crafty:suck(func, caller)

	if not (func() or self:search(caller)) then

		while not func() do
			sleep(0)
			if self.timeout then
				sleep(self.timeout)
			end
		end
	end
end

function Crafty:search(caller)
	local ret = false
	local count = {}
	for i=1,9 do
		if self.table[i] == caller and turtle.getItemCount(self.trans[i]) > 1 then
			count[i] = turtle.getItemCount(self.trans[i])
			ret = true
		end
	end

	if ret then

		local max = 0
		local index = 0
		for i=1,9 do
			if count[i] and count[i] > max then
				max = count[i]
				index = i
			end
		end

		local xfer = math.floor(count[index]/2)
		local oldn = self.selected
		local newn = self.trans[index]
		print("\t\t\t---Transferring "..xfer.." to "..oldn.." from "..newn..".")
		self:select(newn)
		turtle.transferTo(oldn, xfer)
		self:select(oldn)

		return true

	else
		return false
	end

end

function Crafty:suckLeft()
	self:turn(3)
	self:suck(turtle.suck, self.suckLeft)
end

function Crafty:suckRight()
	self:turn(1)
	self:suck(turtle.suck, self.suckRight)
end

function Crafty:suckFront()
	self:turn(0)
	self:suck(turtle.suck, self.suckFront)
end

function Crafty:suckBack()
	self:turn(2)
	self:suck(turtle.suck, self.suckBack)
end

function Crafty:suckUp()
	self:suck(turtle.suckUp, self.suckUp)
end

function Crafty:suckDown()
	self:suck(turtle.suckDown, self.suckDown)
end

function Crafty:turn(s)
	local diff = (self.pos - s) % 4

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
	self.pos = s

end

print("---Loaded Crafty v1.0---")
