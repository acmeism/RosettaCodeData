type Bit = 0..1

proc thueMorse(seqLength: Positive): string =
  var val = Bit(0)
  for n in 0..<seqLength:
    let x = n xor (n - 1)
    if ((x xor x shr 1) and 0x55555555) != 0:
      val = 1 - val
    result.add chr(val + ord('0'))

echo thueMorse(64)
