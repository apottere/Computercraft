turtle.select(1)

while true do
	os.pullEvent("redstone")
	if redstone.getInput("bottom") then
		turtle.drop()
		sleep(0.2)
		turtle.suck()
	end
end
