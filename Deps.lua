print("Loading Deps... ")
Deps = {}

dofile("/get")

Deps.loaded = {}
Deps.loaded["Get"] = true


function Deps.needs(module)
	if Deps.loaded[module] == nil or Deps.loaded[module] == false then
		print("->Deps: Loading module " .. module .. ".")
		Deps.loaded[module] = true
		Deps.load(module)
	else
		print("->Deps: Ignoring module " .. module .. ".")
	end
end

function Deps.unload()
	if fs.exists("/deps") then
		fs.delete("/deps")
	end

	for i,v in ipairs(Deps.loaded) do
		_G[v] = nil
		loadstring(v .. " = nil")()
	end

	dofile("/get")
	Deps.loaded = {}
	Deps.loaded["Get"] = true
end

function Deps.load(module)
	if not fs.exists("/deps") then
		fs.makeDir("/deps")
	else
		if not fs.isDir("/deps") then
			error("Deps: /deps exists and is not a directory.")
		end
	end

	local filename = module .. ".lua"
	if not fs.exists('/deps/' .. filename) then
		Get.main("file", filename, "/deps")
	end

	if not fs.exists('/deps/' .. filename) then
		error("Deps: Unable to resolve dependencies: " .. filename .. " missing.")
	else
		dofile('/deps/' .. filename)
	end
end

print("Finished Deps load.")
