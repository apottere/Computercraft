dofile("/Deps.lua")
Deps.needs("Minor")
Deps.needs("Enderage")

print("Starting")
output = Enderage:newOutput(15)

m = Minor:new(output, 16)

m:cube(3, 2, 2)
m:empty()
