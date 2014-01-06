m = peripheral.wrap("right")
m.setAutoCollect(true)
local numBooks = 0
local currLevel = 0

function refill()
	print("\t->Refilling...")
	while turtle.getItemCount(2) == 0 do
		sleep(0)
		turtle.select(2)
		turtle.suck()
	end
end

function enchantBook()
	print("\t->Enchanting...")
	turtle.select(1)
	if turtle.getItemCount(1) ~= 0 then
		if not turtle.compareTo(2) then
			turtle.dropUp()
			turtle.select(2)
			turtle.transferTo(1, 1)
		end
	else
		turtle.select(2)
		turtle.transferTo(1, 1)

	end

	turtle.select(1)
	while not m.enchant(30) do
		sleep(0)
		print("\t\t->Curr level: " .. m.getLevels())
		sleep(10)
	end
	turtle.dropUp()
end

function run()
	while true do
		print("Enchanting book...")
		sleep(0)
		refill()
		enchantBook()
		print("\t->Dropped.\n")
	end
end

run()
