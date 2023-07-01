const size = 1 shl 4 - 1

for y in countdown(size, 0):
  for i in 0 .. <y:
    stdout.write " "
  for x in 0 .. size-y:
    if (x and y) != 0:
      stdout.write "  "
    else:
      stdout.write "* "
  stdout.write "\n"
