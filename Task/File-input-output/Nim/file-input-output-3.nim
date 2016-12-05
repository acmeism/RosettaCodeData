var
  i = open("input.txt")
  o = open("output.txt", fmWrite)

for line in i.lines:
  o.writeln(line)

i.close()
o.close()
