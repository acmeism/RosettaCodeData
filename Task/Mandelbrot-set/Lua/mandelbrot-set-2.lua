-- Mandelbrot set in Lua 6/15/2020 db
local charmap = { [0]=" ", ".", ":", "-", "=", "+", "*", "#", "%", "@" }
for y = -1.3, 1.3, 0.1 do
  for x = -2.1, 1.1, 0.04 do
    local zi, zr, i = 0, 0, 0
    while i < 100 do
      if (zi*zi+zr*zr >= 4) then break end
      zr, zi, i = zr*zr-zi*zi+x, 2*zr*zi+y, i+1
    end
    io.write(charmap[i%10])
  end
  print()
end
