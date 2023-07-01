cx = -0.7
cy = 0.27015
for y = 0 to 299
  for x = 0 to 299
    zx = (x - 150) / 100
    zy = (y - 150) / 150
    color3 0 0 0
    for iter = 0 to 127
      if zx * zx + zy * zy > 4
        color3 iter / 16 0 0
        break 1
      .
      h = zx * zx - zy * zy + cx
      zy = 2 * zx * zy + cy
      zx = h
    .
    move x / 3 y / 3
    rect 0.4 0.4
  .
.
