
function empty()
	for i=1,16 do
		if turtle.getItemCount(i) ~= 0 then
			turtle.select(i)
			turtle.dropDown()
		end
	end
end

turtle.select(1)

while true do
	empty()
	while not turtle.attack() do
		sleep(0)
	end
end
