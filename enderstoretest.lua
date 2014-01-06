dofile("/Enderage.lua")
dofile("/Gassy.lua")
dofile("/Panic.lua")

output = Enderage:new(15)

Gassy.init(16)


output:store(1, 4)
