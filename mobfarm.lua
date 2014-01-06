turtle.select(1)

while true do
	os.pullEvent("redstone")
	if redstone.getInput("back") then
		turtle.drop()
		sleep(0.2)
		turtle.suck()
	end
end
