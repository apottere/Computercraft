dofile("/Deps.lua")
Deps.needs("Minor")
Deps.needs("Enderage")

output = Enderage:newOutput(15)

m = Minor:new(output, 16)

m:cube(52, 17, 42)
m:empty()
Gassy.home()
