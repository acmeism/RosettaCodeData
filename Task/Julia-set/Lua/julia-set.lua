local cmap = { [0]=" ", ".", ":", "-", "=", "+", "*", "#", "%", "$", "@" }
for y = -1.0, 1.0, 0.05 do
  for x = -1.5, 1.5, 0.025 do
    local zr, zi, i = x, y, 0
    while i < 100 do
      zr, zi = zr*zr - zi*zi - 0.79, zr * zi * 2 + 0.15
      if (zr*zr + zi*zi > 4) then break else i = i + 1 end
    end
    io.write(cmap[math.floor(i/10)])
  end
  print()
end
