local cos, sin, floor, pi = math.cos, math.sin, math.floor, math.pi

function Bitmap:render()
  for y = 1, self.height do
    print(table.concat(self.pixels[y]))
  end
end

function Bitmap:pentagram(x, y, radius, rotation, outlcolor, fillcolor)
  local function pxy(i) return x+radius*cos(i*pi*2/5+rotation), y+radius*sin(i*pi*2/5+rotation) end
  local x1, y1 = pxy(0)
  for i = 1, 5 do
    local x2, y2 = pxy(i*2) -- btw: pxy(i) ==> pentagon
    self:line(floor(x1*2), floor(y1), floor(x2*2), floor(y2), outlcolor)
    x1, y1 = x2, y2
  end
  self:floodfill(floor(x*2), floor(y), fillcolor)
  radius = radius / 2
  for i = 1, 5 do
    x1, y1 = pxy(i)
    self:floodfill(floor(x1*2), floor(y1), fillcolor)
  end
end

bitmap = Bitmap(40*2,40)
bitmap:clear(".")
bitmap:pentagram(20, 22, 20, -pi/2, "@", '+')
bitmap:render()
