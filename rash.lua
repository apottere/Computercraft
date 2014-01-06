-- hello, rash!

-- FUNCTIONS

function trim(s)
	return s:match "^%s*(.-)%s*$"
end

function init()
	ENV = {}
	ENV["path"] = {"/rom/programs/"}
end

function cleanup()
	print("Exiting RaSH gracefully.")
end

function parse(str)
	return trim(str)
end


function eval(str)
	if str == "exit" then
		return 0
	end
	for i = 1, table.getn(ENV["path"]), 1 do
		print(ENV["path"][i])
	end

	return "RaSH: Command not found: "..str
end

-- MAIN

init()
print("Welcome to RaSH \(Reanimated SHell\)!")

while true do
	write("->");
	local out = eval(parse(read()))

	if out == 0 then
		break
	
	else
		print(out)
	end

end
cleanup()

