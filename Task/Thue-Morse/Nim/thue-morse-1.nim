import sequtils, strutils

iterator thueMorse(maxSteps = int.high): string =
  var val = @[0]
  var count = 0
  while true:
    yield val.join()
    inc count
    if count == maxSteps: break
    val &= val.mapIt(1 - it)

for bits in thueMorse(6):
  echo bits
