import strutils

const EmptyRecord = repeat(' ', 64)

#---------------------------------------------------------------------------------------------------

proc textToBlock(infile, outfile: string) =
  ## Read lines of a text file and write them as 64 bytes records.

  let input = infile.open(fmRead)
  defer: input.close()
  let output = outfile.open(fmWrite)
  defer: output.close()

  var count = 0
  while not input.endOfFile:
    var record = input.readLine()
    if record.len > 64:
      record.setLen(64)                         # Truncate to 64 bytes.
    elif record.len < 64:
      record &= repeat(' ', 64 - record.len)    # Pad to 64 bytes.
    if output.writeChars(record, 0, 64) != 64:
      raise newException(IOError, "error while writing block file")
    inc count

  # Complete block with empty records.
  let rem = count mod 16
  if rem != 0:
    for _ in 1..(16 - rem):
      if output.writeChars(EmptyRecord, 0, 64) != 64:
        raise newException(IOError, "error while writing block file")

#---------------------------------------------------------------------------------------------------

proc blockToText(infile, outfile: string) =
  ## Read 64 bytes records and write them as lines trimming spaces.

  let input = infile.open(fmRead)
  defer: input.close()
  let output = outfile.open(fmWrite)
  defer: output.close()

  var line: string
  while not input.endOfFile:
    line.setLen(64)   # Allocate space for the 64 bytes to read.
    if input.readChars(line, 0, 64) != 64:
      raise newException(IOError, "error while reading block file")
    line = line.strip(leading = false, trailing = true) & '\n'
    output.write(line)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  textToBlock("block1.txt", "block.dat")
  blockToText("block.dat", "block2.txt")
