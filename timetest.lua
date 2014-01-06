while true do
	local time = 0
	sleep(0)
	while true do
		sleep(0)
		sleep(2)
		time = time + 2
		if time >= 10 then
			print("time!")
			break
		end
	end
end
