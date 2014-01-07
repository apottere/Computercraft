dofile("/Deps.lua")
Deps.needs("Minor")
Deps.needs("Enderage")

output = Enderage:newOutput(15)

m = Minor:new(output, 16)

m:cube(52, 55, 35)
m:empty()
Gassy.home()
