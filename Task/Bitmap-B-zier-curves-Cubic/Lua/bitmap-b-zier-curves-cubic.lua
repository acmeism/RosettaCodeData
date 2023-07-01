Bitmap.cubicbezier = function(self, x1, y1, x2, y2, x3, y3, x4, y4, nseg)
  nseg = nseg or 10
  local prevx, prevy, currx, curry
  for i = 0, nseg do
    local t = i / nseg
    local a, b, c, d = (1-t)^3, 3*t*(1-t)^2, 3*t^2*(1-t), t^3
    prevx, prevy = currx, curry
    currx = math.floor(a * x1 + b * x2 + c * x3 + d * x4 + 0.5)
    curry = math.floor(a * y1 + b * y2 + c * y3 + d * y4 + 0.5)
    if i > 0 then
      self:line(prevx, prevy, currx, curry)
    end
  end
end

local bitmap = Bitmap(61,21)
bitmap:clear()
bitmap:cubicbezier( 1,1, 15,41, 45,-20, 59,19 )
bitmap:render({[0x000000]='.', [0xFFFFFFFF]='X'})
