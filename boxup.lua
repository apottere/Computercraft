turtle.select(1)

while true do
	os.pullEvent("redstone")
	if redstone.getInput("top") then
		turtle.drop()
		sleep(1)
		turtle.suck()
	end
end
