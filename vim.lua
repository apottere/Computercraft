local state = 0
 
local tArgs = { ... }
 
local x,y = 1,1
local prefx = 1
local w,h = term.getSize()
local tLines = {}
local scrollX, scrollY = 0,0
 
local clipboard = {}
 
local sStatus,sSearch = "",""
 
local bSearchBack = false
 
if #tArgs == 0 then
error("Usage: vim <path>")
end
 
local sPath = shell.resolve(tArgs[1])
local sFileName = string.match(sPath, "[^/]+$")
local bReadOnly = fs.isReadOnly(sPath)
local bReadOnlyW = false
 
if fs.exists(sPath) and fs.isDir(sPath) then
    error("Cannot edit a directory")
end
 
local bNewFile = false
 
local bChanged = false
 
local redrawS
 
 
-- Helper functions
 
local function getFilesize()
    local filesize = 0
    for k,v in pairs(tLines) do
        filesize = filesize + string.len(v)+1
    end
    return filesize
end
 
local function redrawCursor(bsec)
    local size = string.len(tostring(x)) + string.len(tostring(y)) + 4
    local _x,_y = term.getCursorPos()
 
    term.setCursorPos(w - size, h)
 
    if not bsec then
        term.clearLine()
        redrawS(true)
    end
 
    local percent
    if y == 1 then
        percent = "Top"
    elseif y == #tLines then
        percent = "Bot"
    else
        percent = math.floor(y / #tLines * 100) .. "%"
    end
 
    term.write(y .. "," .. x .. " " .. percent)
 
    term.setCursorPos(_x,_y)
end
 
local function redrawStatus(bsec)
    local _x,_y = term.getCursorPos()
    term.setCursorPos(1, h)
    if not bsec then
        term.clearLine()
        redrawCursor(true)
    end
    term.write(sStatus)
    term.setCursorPos(_x,_y)
end
 
local function setStatus(_s)
    sStatus = _s
    redrawStatus()
end
 
local function load()
    local lines = 0
 
    if fs.exists(sPath) then
        local file = io.open(sPath, "r")
        local sLine = file:read()
        while sLine do
            table.insert(tLines, sLine)
            sLine = file:read()
            lines = lines + 1
        end
        file:close()
    else
        table.insert(tLines,"")
        bNewFile = true
    end
 
    local _sStatus = "\"" .. sFileName .. "\""
    if bReadOnly then
        _sStatus = _sStatus .. " [Read Only]"
    elseif bNewFile then
        _sStatus = _sStatus .. " [New File]"
    end
 
    if not bNewFile then
        _sStatus = _sStatus .. " " .. lines .. "L, " .. getFilesize() .. "C"
    end
 
    setStatus(_sStatus)
end
 
local function save()
    local file = io.open(sPath, "w")
    if file then
        for k,v in pairs(tLines) do
            file:write(v .. "\n")
        end
        file:close()
        return true
    end
    return false
end
 
local function redrawText()
    for _y=1, h-1 do
        term.setCursorPos(1 - scrollX, _y)
        term.clearLine()
 
        local sLine = tLines[_y + scrollY]
        if sLine ~= nil then
            term.write(sLine)
        end
    end
 
    term.setCursorPos(x - scrollX, y - scrollY)
end
 
local function setCursor(x, y)
    local screenX = x - scrollX
    local screenY = y - scrollY
 
    local bRedraw = false
 
    if screenX < 1 then
        scrollX = x - 1
        screenX = 1
        bRedraw = true
    elseif screenX > w then
        scrollX = x - w
        screenX = w
        bRedraw = true
    end
 
    if screenY < 1 then
        scrollY = y - 1
        screenY = 1
        bRedraw = true
    elseif screenY > h-1 then
        scrollY = y - (h - 1)
        screenY = h - 1
        bRedraw = true
    end
 
    term.setCursorPos(screenX, screenY)
 
    if bRedraw then redrawText() end
    redrawCursor()
end
 
local function redrawLine()
    local _x,_y = term.getCursorPos()
    term.setCursorPos(1 - scrollX, _y)
    term.clearLine()
    term.write(tLines[y])
    term.setCursorPos(_x, _y)
end
 
local function cursor(param)

	if param == -1 then
		x = 1
		setCursor(x,y)
        return true

	elseif param == -2 then
		x = string.len(tLines[y])
		setCursor(x,y)
        return true

	elseif param == 203 then
        -- Left
        if x > 1 then
            x = x - 1
			prefx = x
            setCursor(x,y)
        end
        return true
    elseif param == 205 then
        -- Right
		if string.len(tLines[y]) > 0 then
			if state == 2 and (x < string.len(tLines[y]) + 1) or (x < string.len(tLines[y])) then
				x = x + 1
				prefx = x
				setCursor(x,y)
			end
		end
        return true
    elseif param == 200 then
        -- Up
        if y > 1 then
            y = y - 1

            local len = string.len(tLines[y])

			if state == 2 then
				if x >= len + 1 or prefx >= len + 1 then
					x = len + 1
				else
					x = prefx
				end
			else
				if x >= len or prefx >= len then
					x = len
				else
					x = prefx
				end
			end

            setCursor(x,y)
        end
        return true
    elseif param == 208 then
        -- Down
        if y < #tLines then
            y = y + 1
            local len = string.len(tLines[y])
			if state == 2 then
				if x >= len + 1 or prefx >= len + 1 then
					x = len + 1
				else
					x = prefx
				end
			else
				if x >= len or prefx >= len then
					x = len
				else
					x = prefx
				end
			end

            setCursor(x,y)
        end
        return true
    elseif param == 199 then
        -- Home
        x = 1
        setCursor(x,y)
        return true
    elseif param == 207 then
        -- End
        x = string.len(tLines[y]) + 1
        setCursor(x,y)
        return true
    elseif param == 201 then
        -- PageUp
        y = y - h + 1
        if y < 1 then y = 1 end
       
        local len = tLines[y]:len()
        if x > len+1 then
            x = len+1
        end
 
        setCursor(x,y)
    elseif param == 209 then
        -- PageDown
        y = y + h - 2
        if y > #tLines then
            y = #tLines
        end
       
        local len = tLines[y]:len()
        if x > len+1 then
            x = len+1
        end
 
        setCursor(x,y)
    end
 
    return false
end
 
local function searchF(s)
    sSearch = s
    for i = x+1, tLines[y]:len() do
        if tLines[y]:sub(i,i+s:len()-1) == s then
            return i,y
        end
    end
    for i = y+1, #tLines do
        if i > #tLines then break end
        for j = 1, tLines[i]:len() do
            if tLines[i]:sub(j,j+s:len()-1):lower() == s:lower() then
                return j,i
            end
        end
    end
    setStatus("search hit BOTTON, continuing at TOP")
    for i = 1, y do
        for j = 1, tLines[i]:len() do
            if tLines[i]:sub(j,j+s:len()-1):lower() == s:lower() then
                return j,i
            end
        end
    end
 
    setStatus("E486: Pattern not found: " .. s)
    return x,y
end
 
local function searchB(s)
    sSearch = s
    bSearchBack = true
    for i = x-1, 1, -1 do
        if x < 1 then break end
        if tLines[y]:sub(i,i+s:len()-1) == s then
            return i,y
        end
    end
    for i = y-1, 1, -1 do
        if i < 1 then break end
        for j = tLines[i]:len(), 1, -1 do
            if tLines[i]:sub(j,j+s:len()-1):lower() == s:lower() then
                return j,i
            end
        end
    end
    setStatus("search hit TOP, continuing at BOTTOM")
    for i = #tLines, y, -1 do
        for j = tLines[i]:len(), 1, -1 do
            if tLines[i]:sub(j,j+s:len()-1):lower() == s:lower() then
                return j,i
            end
        end
    end
    setStatus("E486: Pattern not found: " .. s)
    return x,y
end
 
local function executecmd(rangemin, rangemax, command, amount, force)
    if force == nil then force = false end
    if amount == nil or amount == "" then amount = 1 end
 
    if rangemin > rangemax then
        rangemax = rangemin
    end
 
    if rangemin == 0 and rangemax == 0 then
        rangemin,rangemax = 0,0
    end
 
    local function _quit()
        if bChanged and not force then
            setStatus("E37: No write since last change (add ! to override)")
            state = 0
        else
            setStatus("")
            state = -1
        end
    end
 
    local function _save()
        if bReadOnly and not force then
            setStatus("E45: 'readonly' option is set (add ! to override)")
            state = 0
        else
            if not save() then
                setStatus("E212: Can't open file for writing")
                state = 0
            else
                local _sStatus = "\"" .. sFileName .. "\""
                if bNewFile then
                    _sStatus = _sStatus .. " [New] "
                    bNewFile = false
                end
 
                _sStatus = _sStatus .. " " .. #tLines .. "L, " .. getFilesize() .. "C written"
 
                setStatus(_sStatus)
                bChanged = false
                state = 0
            end
        end
    end
 
    if command == "q" then
        _quit()
    elseif command == "w" then
        _save()
    elseif command == "wq" then
        _save()
        _quit()
    elseif command == "d" then
        local _y = y
        y = rangemin
        if rangemin ~= rangemax then
            amount = rangemax - rangemin + 1
        end
        clipboard = {}
 
        for i = 1, amount do
            if tLines[y] ~= nil then
                table.insert(clipboard,tLines[y])
                table.remove(tLines, y)
               
                if #tLines == 0 then table.insert(tLines, "") end
 
                redrawText()
                bChanged = true
 
                if tLines[y] == nil then
                    y = y - 1
                    break
                end
 
                local len = string.len(tLines[y]) + 1
                if x > len then
                    x = len
                    setCursor(x,y)
                end
            end
        end
        y = _y
 
        state = 0
    elseif command:sub(1,1) == "/" then
        x,y = searchF(command:sub(2))
        setCursor(x,y)
 
        state = 0
 
    elseif command:sub(1,1) == "?" then
        x,y = searchB(command:sub(2))
        setCursor(x,y)
 
        state = 0
 
    elseif command:sub(1,1) == "s" then
       
 
    elseif command == "=" then
        setStatus(#tLines)
        state = 0
    else
        setStatus("E492: Not an editor command: " .. command)
        state = 0
    end
end
 
local function defaultmode()
    local keybuffer = ""
    while state == 0 do
        local sEvent,param = os.pullEvent()
        if sEvent == "key" then
            if param == 28 then param = 208 end
            if param == 14 then param = 203 end
            if cursor(param) then
                bGPressed = false
            end
        elseif sEvent == "char" then
			if param == 'a' then
				state = 2
				if cursor(205) then
					bGPressed = false
				end
			end

			if param == 'h' or param == 'j' or param == 'k' or param == 'l' or param == '$' or param == '0' then
				if param == 'h' then param = 203 end
				if param == 'j' then param = 208 end
				if param == 'k' then param = 200 end
				if param == 'l' then param = 205 end
				if param == '0' then param = -1 end
				if param == '$' then param = -2 end
				if cursor(param) then
					bGPressed = false
				end

			elseif param == 'o' then

				table.insert(tLines,y+1,"")
 
                 redrawText()
 
                 x = 1
                 y = y + 1
                 setCursor(x,y)
                 bChanged = true
				 state = 2

			 elseif param == 'O' then
				table.insert(tLines,y,"")
 
                 redrawText()
 
                 x = 1
                 setCursor(x,y)
                 bChanged = true
				 state = 2


			elseif param == 'x' then
                -- Backspace
                if x <= w then
                    local sLine = tLines[y]
					if x ~= string.len(sLine) then
						tLines[y] = string.sub(sLine,1,x-1) .. string.sub(sLine,x+1)
					else
						tLines[y] = string.sub(sLine,1,x-1)
						if x > 1 then
							x = x - 1
						end
					end
                    redrawLine()
 
                end
 
                setCursor(x,y)
                bChanged = true


			elseif param == 'i' then
                state = 2
            elseif param == ":" then
                state = 1
            elseif param == "G" then
                x = 1
                y = #tLines
                setCursor(x,y)
 
            elseif param == "n" then
                if bSearchBack then
                    setStatus("?" .. sSearch)
                    x,y = searchB(sSearch)
                else
                    setStatus("/" .. sSearch)
                    x,y = searchF(sSearch)
                end
                setCursor(x,y)
 
            elseif param == "N" then
                if bSearchBack then
                    setStatus("/" .. sSearch)
                    x,y = searchF(sSearch)
                else
                    setStatus("?" .. sSearch)
                    x,y = searchB(sSearch)
                end
 
            elseif param == "p" then
                for i = #clipboard, 1, -1 do
                    table.insert(tLines,y+1,clipboard[i])
                end
                redrawText()
                bChanged = true
 
            elseif param == "P" then
                for i = #clipboard, 1, -1 do
                    table.insert(tLines,y,clipboard[i])
                end
                redrawText()
                bChanged = true
            end
 
            if param == "g" then
                if keybuffer == "g" then
                    x = 1
                    y = 1
                    setCursor(x,y)
 
                    keybuffer = ""
                else
                    keybuffer = "g"
                end
 
            elseif param == "y" then
                if keybuffer == "y" then
                    clipboard = {tLines[y]}
                    keybuffer = ""
                else
                    keybuffer = "y"
                end
 
            elseif param == "d" then
                if keybuffer == "d" then
                    clipboard = {tLines[y]}
                    table.remove(tLines,y)
                    if #tLines == 0 then table.insert(tLines,"") end
 
                    redrawText()
 
                    if y > #tLines then
                        y = y - 1
                        setCursor(x,y)
                    end
                    if x > tLines[y]:len()+1 then
                        x = tLines[y]:len()
                        setCursor(x,y)
                    end
 
                    bChanged = true
 
                    keybuffer = ""
                else
                    keybuffer = "d"
                end
            else
                keybuffer = ""
            end
        end
    end
end
 
local function commandmode()
    local command = ":"
 
    term.setCursorPos(2,h)
 
    setStatus(":")
 
    while state == 1 do
        local _x,_y = term.getCursorPos()
        local sEvent,param = os.pullEvent()
 
        if sEvent == "key" then
            if param == 28 then
                -- Return
                command = command:sub(2)
 
                if command:sub(1,1) == "s" or command:sub(1,1) == "/" or command:sub(1,1) == "?" then
                    executecmd(0,0,command,0,false)
                else
                    local _,_,minmax,cmd,amnt,force = command:find("(%d*,?%d*)([a-zA-Z=]*)(%d*)(!?)")
                    local minim,maxim = 0,0
 
                    local i = 1
                    local minmax2,flag = minmax:sub(i,i), false
                    while minmax2 ~= "" do
                        if minmax2 == "," then
                            flag = true
                        else
                            if flag then
                                maxim = maxim * 10 + tonumber(minmax2)
                            else
                                minim = minim * 10 + tonumber(minmax2)
                            end
                        end
                        i = i + 1
                        minmax2 = minmax:sub(i,i)
                    end
 
                    executecmd(minim,maxim,cmd,amnt,force == "!")
                end
            elseif param == 59 or param == 41 then
                -- F1
                state = 0

            elseif param == 14 then
                -- Backspace
                if _x > 1 then
                    command = string.sub(command,1,_x-2) .. string.sub(command,_x)
                    _x = _x - 1
                    term.setCursorPos(_x,_y)
                end
                if command == "" then
                    state = 0
                end
                setStatus(command)
            elseif param == 203 then
                -- Left
                if _x > 1 then
                    _x = _x + 1
                    term.setCursorPos(_x,_y)
                end
            end
        elseif sEvent == "char" then
            command = string.sub(command,1,_x-1) .. param .. string.sub(command,_x)
            setStatus(command)
            _x = _x + 1
            term.setCursorPos(_x,_y)
        end
    end
 
    setCursor(x,y)
end
 
local function insertmode()
    local _sStatus = "-- INSERT -- "
    if bReadOnly and not bReadOnlyW then
        _sStatus = _sStatus .. " W10: Changing a readonly file"
        bReadOnlyW = true
    end
 
    setStatus(_sStatus)
 
    while state == 2 do
        local sEvent,param = os.pullEvent()
        if sEvent == "key" and not cursor(param) then
             if param == 59 or param == 41 then
                 -- F1
				 state = 0
				 if x < 1 then x = x - 1 end
				 setCursor(x,y)
             elseif param == 28 then
                 -- Return
                 local sLine = tLines[y]
                 tLines[y] = string.sub(sLine,1,x-1)
                 table.insert(tLines,y+1,string.sub(sLine,x))
 
                 redrawText()
 
                 x = 1
                 y = y + 1
                 setCursor(x,y)
                 bChanged = true
             elseif param == 14 then
                -- Backspace
                if x > 1 then
                    local sLine = tLines[y]
                    tLines[y] = string.sub(sLine,1,x-2) .. string.sub(sLine,x)
                    redrawLine()
 
                    x = x - 1
                elseif y > 1 then
                    local sPrevLine = tLines[y-1]
                    tLines[y-1] = sPrevLine .. tLines[y]
                    table.remove(tLines, y)
 
                    redrawText()
 
                    x = string.len(sPrevLine) + 1
                    y = y - 1
                end
 
                setCursor(x,y)
                bChanged = true
 
            elseif param == 211 then
                -- Del
                local sLine = tLines[y]
                local len = string.len(sLine)+1
                if x < len then
                    tLines[y] = string.sub(sLine,1,x-1) .. string.sub(sLine,x+1)
                    redrawLine()
                elseif y < #tLines then
                    tLines[y] = sLine .. tLines[y+1]
                    table.remove(tLines, y+1)
                    redrawText()
                end
 
                bChanged = true
            elseif param == 15 then
                -- Tab
                local sLine = tLines[y]
                tLines[y] = string.sub(sLine,1,x-1) .. "    " .. string.sub(sLine,x)
                redrawLine()
 
                x = x + 4
                setCursor(x,y)
 
                bChanged = true
            end
 
        elseif sEvent == "char" then
            local sLine = tLines[y]
            tLines[y] = string.sub(sLine,1,x-1) .. param .. string.sub(sLine,x)
            redrawLine()
 
            x = x + string.len(param)
            setCursor(x,y)
 
            bChanged = true
        end
    end
    setStatus("")
end
 
local function tsmode()
 
end
 
-- Main routine
 
local tModes = {}
tModes[0] = defaultmode
tModes[1] = commandmode
tModes[2] = insertmode
tModes[3] = tsmode
 
term.clear()
term.setCursorPos(1,1)
term.setCursorBlink(true)
 
load()
redrawText()
 
redrawS = redrawStatus
 
redrawCursor()
 
while state ~= -1 do
    tModes[state]()
end
term.clear()
term.setCursorPos(1,1)
