print("Loading Turtles...")
Deps.needs("Gassy")

Turtles = {}
Turtles.forward = nil
Turtles.up = 2
Turtles.down = 3

Turtles.moveSet = {
	Gassy.forward,
	Gassy.up,
	Gassy.down
}

Turtles.digSet = {
	turtle.dig,
	turtle.digUp,
	turtle.digDown
}

Turtles.detectSet = {
	turtle.detect,
	turtle.detectUp,
	turtle.detectDown
}

Turtles.attackSet = {
	turtle.attack,
	turtle.attackUp,
	turtle.attackDown
}

Turtles.placeSet = {
	turtle.place,
	turtle.placeUp,
	turtle.placeDown
}

function Turtles.action(set, dir)
	return set[Turtles.determine(dir)]()
end

function Turtles.move(dir)
	return Turtles.action(Turtles.moveSet, dir)
end

function Turtles.dig(dir)
	return Turtles.action(Turtles.digSet, dir)
end

function Turtles.detect(dir)
	return Turtles.action(Turtles.detect, dir)
end

function Turtles.attack(dir)
	return Turtles.action(Turtles.attackSet, dir)
end

function Turtles.place(dir)
	return Turtles.action(Turtles.placeSet, dir)
end

function Turtles.determine(dir)
	if dir == nil then
		return 1
	else
		return dir
	end
end


print("Finished Turtles load.")