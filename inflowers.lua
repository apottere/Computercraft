dofile("/Enderage.lua")

bonemeal = Enderage:new(1, 16)
redstone.setOutput("back", true)
bonemeal:sel()

while true do
	sleep(0)
	sleep(0.5)
	bonemeal:placeDown()
	sleep(0.5)
	redstone.setOutput("back", false)
	sleep(2)
	redstone.setOutput("back", true)
	sleep(2)
end
