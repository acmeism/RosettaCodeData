import memfiles

var
  i = memfiles.open("input.txt")
  o = system.open("output.txt", fmWrite)

var written = o.writeBuffer(i.mem, i.size)
assert(written == i.size)

i.close()
o.close()
