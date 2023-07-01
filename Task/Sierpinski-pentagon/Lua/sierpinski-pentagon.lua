Bitmap.chaosgame = function(self, n, r, niters)
  local w, h, vertices = self.width, self.height, {}
  for i = 1, n do
    vertices[i] = {
      x = w/2 + w/2 * math.cos(math.pi/2+(i-1)*math.pi*2/n),
      y = h/2 - h/2 * math.sin(math.pi/2+(i-1)*math.pi*2/n)
    }
  end
  local x, y = w/2, h/2
  for i = 1, niters do
    local v = math.random(n)
    x = x + r * (vertices[v].x - x)
    y = y + r * (vertices[v].y - y)
    self:set(x,y,0xFFFFFFFF)
  end
end

local bitmap = Bitmap(128, 128)
bitmap:chaosgame(5, 1/((1+math.sqrt(5))/2), 1e6)
bitmap:render({[0x000000]='..', [0xFFFFFFFF]='██'})
