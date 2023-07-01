proc binDigits(x: BiggestInt, r: int): int =
  ## Calculates how many digits `x` has when each digit covers `r` bits.
  result = 1
  var y = x shr r
  while y > 0:
    y = y shr r
    inc(result)

proc toBin*(x: BiggestInt, len: Natural = 0): string =
  ## converts `x` into its binary representation. The resulting string is
  ## always `len` characters long. By default the length is determined
  ## automatically. No leading ``0b`` prefix is generated.
  var
    mask: BiggestInt = 1
    shift: BiggestInt = 0
    len = if len == 0: binDigits(x, 1) else: len
  result = newString(len)
  for j in countdown(len-1, 0):
    result[j] = chr(int((x and mask) shr shift) + ord('0'))
    shift = shift + 1
    mask = mask shl 1

for i in 0..15:
  echo toBin(i)
