size = 500
math.randomseed(os.time())

-- Writes a 256-bit grayscale PGM image file:
function writePgm(data, fn, comment)
  local rows = #data
  local cols = #data[1]
  local file = io.open(fn, "wb")

  -- Write header in ASCII
  file:write("P5", "\n")
  if comment ~= nil then
    file:write("# ", comment, "\n")
  end
  file:write(cols, " ", rows, "\n")
  file:write("255", "\n")
  -- Write data in raw bytes
  for _, r in ipairs(data) do
    file:write(string.char(unpack(r)))
  end
  file:close()
end

img = {}
for r = 1, size do
  img[r] = {}
  for c = 1, size do
    img[r][c] = math.random(0,255)
  end
end

writePgm(img, "prng_img.pgm", string.format("PRNG Image (%d x %d)", size, size))
