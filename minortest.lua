dofile("/Deps.lua")
Deps.needs("Minor")
Deps.needs("Enderage")

output = Enderage:newOutput(15)

m = Minor:new(output, 16)

m:cube(3, 3, 4)
m:empty()
