import math, strformat, strutils


func entropy(str: string): float =
  ## return the entropy of a fibword string.
  if str.len <= 1: return 0.0
  let strlen = str.len.toFloat
  let count0 = str.count('0').toFloat
  let count1 = strlen - count0
  result = -(count0 / strlen * log2(count0 / strlen) + count1 / strlen * log2(count1 / strlen))


iterator fibword(): string =
  ## Yield the successive fibwords.
  var a = "1"
  var b = "0"
  yield a
  yield b
  while true:
    a = b & a
    swap a, b
    yield b


when isMainModule:
  echo " n    length       entropy"
  echo "————————————————————————————————"
  var n = 0
  for str in fibword():
    inc n
    echo fmt"{n:2}  {str.len:8}  {entropy(str):.16f}"
    if n == 37: break
