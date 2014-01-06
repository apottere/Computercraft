while true do
  event, button, xPos, yPos = os.pullEvent("mouse_click")
  print(event .. " => " .. tostring(button) .. ": " .. tostring(button) .. ", " ..
    "X: " .. tostring(xPos) .. ", " ..
    "Y: " .. tostring(yPos))
end
