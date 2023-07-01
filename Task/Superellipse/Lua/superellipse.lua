local abs,cos,floor,pi,pow,sin = math.abs,math.cos,math.floor,math.pi,math.pow,math.sin
local bitmap = {
  init = function(self, w, h, value)
    self.w, self.h, self.pixels = w, h, {}
    for y=1,h do self.pixels[y]={} end
    self:clear(value)
  end,
  clear = function(self, value)
    for y=1,self.h do
      for x=1,self.w do
        self.pixels[y][x] = value or "  "
      end
    end
  end,
  set = function(self, x, y, value)
    x,y = floor(x+0.5),floor(y+0.5)
    if x>0 and y>0 and x<=self.w and y<=self.h then
      self.pixels[y][x] = value or "#"
    end
  end,
  superellipse = function(self, ox, oy, n, a, b, c)
    local function sgn(n) return n>=0 and 1 or -1 end
    for t = 0, 1, 0.002 do
      local theta = t * 2 * pi
      local x = ox + a * pow(abs(cos(theta)), 2/n) * sgn(cos(theta))
      local y = oy + b * pow(abs(sin(theta)), 2/n) * sgn(sin(theta))
      self:set(x, y, c)
    end
  end,
  render = function(self)
    for y=1,self.h do
      print(table.concat(self.pixels[y]))
    end
  end,
}

bitmap:init(80, 60, "..")
bitmap:superellipse(40, 30, 2.5, 38, 28, "[]")
bitmap:render()
