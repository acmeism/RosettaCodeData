local nw = require("nw")
local app = nw:app()
local cw, ch = 320, 240
local win = app:window(cw, ch, "Color Bars", false)
local colors = {{0,0,0}, {1,0,0}, {0,1,0}, {0,0,1}, {1,0,1}, {0,1,1}, {1,1,0}, {1,1,1}}
local unpack = unpack or table.unpack -- polyfill 5.2 vs 5.3
function win:repaint()
  local cr = win:bitmap():cairo()
  for i = 1, #colors do
    cr:rectangle((i-1)*cw/#colors, 0, cw/#colors, ch)
    cr:rgb(unpack(colors[i]))
    cr:fill()
  end
end
win:show()
app:run()
