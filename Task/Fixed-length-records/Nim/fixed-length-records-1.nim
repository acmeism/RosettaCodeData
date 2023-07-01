import algorithm

proc reverse(infile, outfile: string) =

  let input = infile.open(fmRead)
  defer: input.close()
  let output = outfile.open(fmWrite)
  defer: output.close()

  var buffer: array[80, byte]
  while not input.endOfFile:
    let countRead = input.readBytes(buffer, 0, 80)
    if countRead < 80:
      raise newException(IOError, "truncated data when reading")
    buffer.reverse()
    let countWrite = output.writeBytes(buffer, 0, 80)
    if countWrite < 80:
      raise newException(IOError, "truncated data when writing")

reverse("infile.dat", "outfile.dat")
