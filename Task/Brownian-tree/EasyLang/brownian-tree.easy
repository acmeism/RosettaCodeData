color3 0 1 1
len f[] 200 * 200
move 50 50
rect 0.5 0.5
f[100 * 200 + 100] = 1
n = 9000
while i < n
  repeat
    x = random 200 - 1
    y = random 200 - 1
    until f[y * 200 + x + 1] <> 1
  .
  while 1 = 1
    xo = x
    yo = y
    x += random 3 - 2
    y += random 3 - 2
    if x < 0 or y < 0 or x >= 200 or y >= 200
      break 1
    .
    if f[y * 200 + x + 1] = 1
      move xo / 2 yo / 2
      rect 0.5 0.5
      f[yo * 200 + xo + 1] = 1
      i += 1
      if i mod 16 = 0
        color3 0.2 + i / n 1 1
        sleep 0
      .
      break 1
    .
  .
.
