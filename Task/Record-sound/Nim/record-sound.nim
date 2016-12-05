proc record(bytes): auto =
  var f = open("/dev/dsp")
  result = newSeq[int8](bytes)
  discard f.readBytes(result, 0, bytes)

proc play(buf) =
  var f = open("/dev/dsp", fmWrite)
  f.write(buf)
  f.close

var p = record(65536)
play(p)
