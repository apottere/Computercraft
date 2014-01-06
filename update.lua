local tArgs = { ... }
local program = tArgs[1]
shell.run("rm", "startup")
shell.run("get", "file", program)
shell.run("cp", program, "startup")
os.reboot()
