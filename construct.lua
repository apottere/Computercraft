dofile("/Enderage.lua")
dofile("/Gassy.lua")
dofile("/Cons.lua")
dofile("Panic.lua")

bricks = Enderage:new(1, 15)
glass = Enderage:new(2, 14)

Gassy.init(16)


local argv = { ... }
local t = type(argv[1])

if argv[1] == nil then
	error("No argument given.")

elseif t == "list" then
	Cons.parts(bricks, glass, argv[1])

elseif t == "string" then
	Cons.buildFrom(bricks, glass, tonumber(argv[1]))

end
