type
  BitWriter * = tuple
    file: File
    bits: uint8
    nRemain: int

  BitReader * = tuple
    file: File
    bits: uint8
    nRemain: int
    nRead: int

proc newBitWriter * (file: File) : ref BitWriter =
  result = new BitWriter
  result.file = file
  result.bits = 0
  result.nRemain = 8

proc flushBits (stream : ref BitWriter) =
  discard stream.file.writeBuffer(stream.bits.addr, 1)
  stream.nRemain = 8
  stream.bits = 0

proc write * (stream: ref BitWriter, bits: uint8, nBits: int) =
  assert(nBits <= 8)

  for ii in countdown((nBits - 1), 0) :
    stream.bits = (stream.bits shl 1) or ((bits shr ii) and 1)
    stream.nRemain.dec(1)
    if stream.nRemain == 0:
      stream.flushBits

proc flush * (stream: ref BitWriter) =
  if stream.nRemain < 8:
    stream.bits = stream.bits shl stream.nRemain
    stream.flushBits

proc newBitReader * (file: File) : ref BitReader =
  result = new BitReader
  result.file = file
  result.bits = 0
  result.nRemain = 0
  result.nRead = 0

proc read * (stream: ref BitReader, nBits: int) : uint8 =
  assert(nBits <= 8)

  result = 0
  for ii in 0 ..< nBits :
    if stream.nRemain == 0:
      stream.nRead = stream.file.readBuffer(stream.bits.addr, 1)
      if stream.nRead == 0:
        break
      stream.nRemain = 8

    result = (result shl 1) or ((stream.bits shr 7) and 1)

    stream.bits = stream.bits shl 1
    stream.nRemain.dec(1)


when isMainModule:
  var
    file: File
    writer: ref BitWriter
    reader: ref BitReader

  file = open("testfile.dat", fmWrite)
  writer = newBitWriter(file)

  for ii in 0 .. 255:
    writer.write(ii.uint8, 7)

  writer.flush
  file.close

  var dataCtr = 0

  file = open("testfile.dat", fmRead)
  reader = newBitReader(file)

  while true:
    let aByte = reader.read(7)

    if reader.nRead == 0:
      break

    assert((dataCtr and 0x7f).uint8 == aByte)

    inc dataCtr

  assert(dataCtr == 256)

  file.close

  echo "OK"
