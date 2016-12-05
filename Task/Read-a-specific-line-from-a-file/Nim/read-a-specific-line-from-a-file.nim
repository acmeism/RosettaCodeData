var
  line: TaintedString
  f = open("test.txt", fmRead)

for x in 0 .. 6:
  try:
    line = readLine f
  except EIO:
    echo "Not 7 lines in file"
