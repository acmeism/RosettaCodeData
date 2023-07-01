import strutils

proc cline(n, x, y: int, cde: string) =
  echo cde[0..0].align n+1,
    repeat(cde[1], 9*x-1),
    cde[0],
    if cde.len > 2: cde[2..2].align y+1 else: ""

proc cuboid(x, y, z: int) =
  cline y+1, x, 0, "+-"
  for i in 1..y: cline y-i+1, x, i-1, "/ |"
  cline 0, x, y, "+-|"
  for i in 0..4*z-y-3: cline 0, x, y, "| |"
  cline 0, x, y, "| +"
  for i in countdown(y-1, 0): cline 0, x, i, "| /"
  cline 0, x, 0, "+-\n"

cuboid 2, 3, 4
cuboid 1, 1, 1
cuboid 6, 2, 1
