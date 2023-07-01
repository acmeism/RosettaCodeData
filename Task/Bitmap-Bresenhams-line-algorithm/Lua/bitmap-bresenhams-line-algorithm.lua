-----------------------------------------------
-- Bitmap replacement
-- (why? current Lua impl lacks a "set" method)
-----------------------------------------------
local Bitmap = {
  new = function(self, width, height)
    local instance = setmetatable({ width=width, height=height }, self)
    instance:alloc()
    return instance
  end,
  alloc = function(self)
   self.pixels = {}
    for y = 1, self.height do
      self.pixels[y] = {}
      for x = 1, self.width do
        self.pixels[y][x] = 0x00000000
      end
    end
  end,
  clear = function(self, c)
    for y = 1, self.height do
      for x = 1, self.width do
        self.pixels[y][x] = c or 0x00000000
      end
    end
  end,
  get = function(self, x, y)
    x, y = math.floor(x+1), math.floor(y+1)
    if ((x>=1) and (x<=self.width) and (y>=1) and (y<=self.height)) then
      return self.pixels[y][x]
    else
      return nil
    end
  end,
  set = function(self, x, y, c)
    x, y = math.floor(x+1), math.floor(y+1)
    if ((x>=1) and (x<=self.width) and (y>=1) and (y<=self.height)) then
      self.pixels[y][x] = c or 0x00000000
    end
  end,
}
Bitmap.__index = Bitmap
setmetatable(Bitmap, { __call = function (t, ...) return t:new(...) end })

------------------------------
-- Bresenham's Line Algorithm:
------------------------------
Bitmap.line = function(self, x1, y1, x2, y2, c)
  local dx, sx = math.abs(x2-x1), x1<x2 and 1 or -1
  local dy, sy = math.abs(y2-y1), y1<y2 and 1 or -1
  local err = math.floor((dx>dy and dx or -dy)/2)
  while(true) do
    self:set(x1, y1, c or 0xFFFFFFFF)
    if (x1==x2 and y1==y2) then break end
    if (err > -dx) then
      err, x1 = err-dy, x1+sx
      if (x1==x2 and y1==y2) then
        self:set(x1, y1, c or 0xFFFFFFFF)
        break
      end
    end
    if (err < dy) then
      err, y1 = err+dx, y1+sy
    end
  end
end

--------
-- Demo:
--------
Bitmap.render = function(self, charmap)
  for y = 1, self.height do
    local rowtab = {}
    for x = 1, self.width do
      rowtab[x] = charmap[self.pixels[y][x]]
    end
    print(table.concat(rowtab))
  end
end
local bitmap = Bitmap(61,21)
bitmap:clear()
bitmap:line(0,10,30,0)
bitmap:line(30,0,60,10)
bitmap:line(60,10,30,20)
bitmap:line(30,20,0,10)
bitmap:render({[0x000000]='.', [0xFFFFFFFF]='X'})
