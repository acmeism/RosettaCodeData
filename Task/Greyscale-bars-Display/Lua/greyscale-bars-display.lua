local nw = require("nw")
local app = nw:app()
local cw, ch = 320, 240
local win = app:window(cw, ch, "Grayscale Bars", false)
function win:repaint()
  local cr = win:bitmap():cairo()
  local ystride = ch/4
  for y = 0, 3 do
    local i, n = 1, 2^(y+3)
    local xstride = cw/n
    for x = 0, n-1 do
      cr:rectangle(x*xstride, y*ystride, xstride, ystride)
      local gray = x / (n-1)
      if y%2>0 then gray=1-gray end
      cr:rgb(gray, gray, gray)
      cr:fill()
    end
  end
end
win:show()
app:run()
