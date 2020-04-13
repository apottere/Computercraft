dofile("/Deps.lua")
Deps.needs("Enderage")
Deps.needs("Gassy")
Deps.needs("Cons")

stone = Enderage:new(1, 15)
Gassy.init(16)


local argv = { ... }
local t = type(argv[1])


Cons.eFloor(41, 6, stone)
Gassy.home()
