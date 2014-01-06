dofile("/Enderage.lua")
dofile("/Gassy.lua")
dofile("/Cons.lua")
dofile("/Panic.lua")

bricks = Enderage:new(1, 15)

Gassy.init(16)

local argv = { ... }
x = argv[1]
z = argv[2]

Cons.eFloor(x, z, bricks)
