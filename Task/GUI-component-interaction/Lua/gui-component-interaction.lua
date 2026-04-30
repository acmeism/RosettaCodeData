local ui = require "ui"
math.randomseed(os.time())

local win = ui.Window("GUI component interaction", 320, 200)

local entry = ui.Entry(win, 0, 124, 40)
entry.enabled = false

ui.Button(win, "Increment", 105, 90).onClick = function (self)
  entry.text = entry.text + 1
end

ui.Button(win, "Random", 110, 130).onClick = function (self)
  if ui.confirm("Set the field to a random number?") == "yes" then
    entry.text = math.random(100)
  end

end

win:show()
-- update the user interface until the user closes the Window
repeat
  sleep(1)
  ui.update()
until not win.visible
