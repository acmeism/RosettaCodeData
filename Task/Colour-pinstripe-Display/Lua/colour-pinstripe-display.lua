local nw = require("nw")
local app = nw:app()
local cw, ch = 320, 240
local win = app:window(cw, ch, "Color Pinstripe", false)
local colors = {{0,0,0}, {1,0,0}, {0,1,0}, {0,0,1}, {1,0,1}, {0,1,1}, {1,1,0}, {1,1,1}}
local unpack = unpack or table.unpack -- polyfill 5.2 vs 5.3
function win:repaint()
  local cr = win:bitmap():cairo()
  local ystride = ch/4
  for y = 0, ch-1, ystride do
    local i, xstride = 1, y/ystride+1
    for x = 0, cw-1, xstride do
      cr:rectangle(x, y, xstride, ystride)
      cr:rgb(unpack(colors[i]))
      cr:fill()
      i = (i % #colors) + 1
    end
  end
end
win:show()
app:run()
