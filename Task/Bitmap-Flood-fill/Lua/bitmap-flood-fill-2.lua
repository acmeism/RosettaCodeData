function Bitmap:loadPPM(filename)
  local fp = io.open( filename, "rb" )
  if fp == nil then return false end
  local head, width, height, depth, tail = fp:read("*line", "*number", "*number", "*number", "*line")
  self.width, self.height = width, height
  self:alloc()
  for y = 1, self.height do
    for x = 1, self.width do
      self.pixels[y][x] = { string.byte(fp:read(1)), string.byte(fp:read(1)), string.byte(fp:read(1)) }
    end
  end
  fp:close()
end

function Bitmap:savePPM(filename)
  local fp = io.open( filename, "wb" )
  if fp == nil then return false end
  fp:write(string.format("P6\n%d %d\n%d\n", self.width, self.height, 255))
  for y = 1, self.height do
    for x = 1, self.width do
      local pix = self.pixels[y][x]
      fp:write(string.char(pix[1]), string.char(pix[2]), string.char(pix[3]))
    end
  end
  fp:close()
end
