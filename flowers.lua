redstone.setOutput("bottom", false)
redstone.setOutput("top", false)
redstone.setOutput("left", false)

delay = 6*60*60
duration = 30

while true do
	sleep(0)

	if redstone.getInput("top") then
		print("Stopping and waiting...")
		redstone.setOutput("bottom", true)
		redstone.setOutput("left", true)
		sleep(1)
		redstone.setOutput("left", false)
		redstone.setOutput("bottom", false)
		sleep(delay)
	else
		print("Clearing flowers...")
		redstone.setOutput("bottom", true)
		redstone.setOutput("left", true)
		sleep(1)
		redstone.setOutput("left", false)
		redstone.setOutput("bottom", false)
		sleep(duration)
	end
end

