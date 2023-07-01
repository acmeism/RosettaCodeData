Bitmap.loadPPM = function(self, filename)
  local fp = io.open( filename, "rb" )
  if fp == nil then return false end
  local head, width, height, depth, tail = fp:read("*line", "*number", "*number", "*number", "*line")
  self.width, self.height = width, height
  self:alloc()
  self:clear( {0,0,0} )
  for y = 1, self.height do
    for x = 1, self.width do
      self.pixels[y][x] = { string.byte(fp:read(1)), string.byte(fp:read(1)), string.byte(fp:read(1)) }
    end
  end
  fp:close()
  return true
end

Bitmap.percentageDifference = function(self, other)
  if self.width ~= other.width or self.height ~= other.height then return end
  local dif, abs, spx, opx = 0, math.abs, self.pixels, other.pixels
  for y = 1, self.height do
    for x = 1, self.width do
      local sp, op = spx[y][x], opx[y][x]
      dif = dif + abs(sp[1]-op[1]) + abs(sp[2]-op[2]) + abs(sp[3]-op[3])
    end
  end
  return dif/255/self.width/self.height/3*100
end

local bm50 = Bitmap(0,0)
bm50:loadPPM("Lenna50.ppm")

local bm100 = Bitmap(0,0)
bm100:loadPPM("Lenna100.ppm")

print("%diff:", bm100:percentageDifference(bm50))
