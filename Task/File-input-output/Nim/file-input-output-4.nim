const size = 4096

var
  i = open("input.txt")
  o = open("output.txt", fmWrite)
  buf: array[size, char]

while i.readBuffer(buf.addr, size) > 0:
  discard o.writeBuffer(buf.addr, size)

i.close()
o.close()
