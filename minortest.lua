dofile("/Enderage.lua")
dofile("/Gassy.lua")
dofile("/Panic.lua")
dofile("/Minor.lua")

output = Enderage:newOutput(15)

m = Minor:new(output, 16)

m:cube(52, 55, 20)
--m:cube(3, 3, 2)
m:empty()
