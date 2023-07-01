var
  i = open("input.txt")
  o = open("output.txt", fmWrite)

for line in i.lines:
  o.writeLine(line)

i.close()
o.close()
