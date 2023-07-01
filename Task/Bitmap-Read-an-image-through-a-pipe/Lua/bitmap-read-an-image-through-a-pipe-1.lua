function Bitmap:loadPPM(filename, fp)
  if not fp then fp = io.open(filename, "rb") end
  if not fp then return end
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
