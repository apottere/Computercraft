--books = { 1="Dome" }


books = {
	"Let me out!",
	"Andy's Magic Island",
	"Order of Rose Aflame",
	"Oz",
	"Rody",
	"RockPtarmargiman",
	"Christina",
}
book_max = table.getn(books)

latest = {}

rednet.open("back")
pitid = 16
selected = 1
ready = false
go_color = colors.red

function init()

	sign = peripheral.wrap("left")
	sign.setBackgroundColor(colors.black)
	print_sign(colors.red)
	sleep(5)
	rednet.send(pitid, "1")
	
	disp = peripheral.wrap("top")
	disp.setBackgroundColor(colors.black)
	print_disp()

end

function print_sign(color)
	sign.clear()
	sign.setTextColor(color)
	sign.setCursorPos(1,2)
	sign.write(" Right")
	sign.setCursorPos(1,3)
	sign.write(" Click")
	sign.setCursorPos(1,4)
	sign.write(" ---->")


end

function print_disp()

	disp.clear()
	disp.setCursorPos(1,1)
	disp.write("Latest dests: ")
	disp.setCursorPos(1,2)
	disp.setTextColor(colors.yellow)
	disp.write("------------------")
	disp.setTextColor(colors.white)

	for i = 1, 9 do
		disp.setCursorPos(1,i+3)
		disp.write(i..":")

	end

	disp.setTextColor(colors.cyan)
	for i,v in ipairs(latest) do
		if i > 9 then
			break
		end
		disp.setCursorPos(4, i+3)
		disp.write(books[v])
	end
	disp.setTextColor(colors.white)

end

function print_menu()
	
	term.clear()
	term.setCursorPos(1,1)
	for i,v in ipairs(books) do

		local num
		if i == selected then
			num = " -->"
		else
			num = "    "
		end

		term.setCursorPos(1, i)
		term.write(num)
		term.setCursorPos(6, i)
		term.setTextColor(colors.cyan)
		term.write(books[i]) 
		term.setTextColor(colors.white)

	end
	term.setTextColor(colors.yellow)
	for i = 1, 19 do
		term.setCursorPos(30, i)
		term.write("|")
	end

	term.setTextColor(colors.lime)
	term.setCursorPos(31, 2)
	term.write(" <- Click selection")
	term.setTextColor(colors.white)

	print_go(go_color)

end

function print_go(color)
	
	term.setTextColor(color)
	local left = 34
	local top = 8
	term.setCursorPos(left, top + 0)
	term.write("  ####   ####  ")
	term.setCursorPos(left, top + 1)
	term.write(" ##     ##  ## ")
	term.setCursorPos(left, top + 2)
	term.write(" ## ### ##  ## ")
	term.setCursorPos(left, top + 3)
	term.write(" ##  ## ##  ## ")
	term.setCursorPos(left, top + 4)
	term.write("  ####   ####  ")
	term.setTextColor(colors.white)


end

init()

while true do
	print_menu()
	print_disp()
	local event, click, x, y = os.pullEvent()

	if event == "mouse_click" then

		if x <= 29 and y <= book_max then
			selected = y

		elseif ready and x >= 31 then
			ready = false
			print_sign(colors.red)
			go_color = colors.red
			print_go(go_color)
			if table.getn(latest) > 9 then
				table.remove(latest, 10)
			end
			table.insert(latest, 1, selected)
			rednet.send(pitid, ""..selected)
		end
	
	elseif event == "rednet_message" then

		if (click == pitid and x == "ready") then
			ready = true
			print_sign(colors.lime)
			go_color = colors.lime
			print_go(go_color)
		else
			print("Haxorz: ID: "..click..", msg: "..x..".")
		end
	end
end
