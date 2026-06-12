import bitops, random, sequtils, strutils

type Vector = seq[float]

func reorderingSign(i, j: int): float =
  var i = i shr 1
  var sum = 0
  while i != 0:
    sum += countSetBits(i and j)
    i = i shr 1
  result = if (sum and 1) == 0: 1 else: -1

func e(n: Natural): Vector =
  result.setLen(32)
  assert n < 5, "index must be less than 5; got $#.".format(n)
  result[1 shl n] = 1

func `+`(a, b: Vector): Vector =
  result.setLen(32)
  for i in 0..b.high:
    result[i] = a[i] + b[i]

func `*`(a, b: Vector): Vector =
  result.setLen(32)
  for i in 0..a.high:
    if a[i] != 0:
      for j in 0..b.high:
        if b[j] != 0:
          let s = reorderingSign(i, j) * a[i] * b[j]
          let k = i xor j
          result[k] += s

func dot(a, b: Vector): Vector =
  (a * b + b * a) * @[0.5]

proc randomVector(): Vector =
  result.setLen(32)
  for i in 0..4:
    result = result + @[rand(1.0)] * e(i)

proc randomMultiVector(): Vector =
  newSeqWith(32, rand(1.0))


when isMainModule:

  randomize()
  for i in 0..4:
    for j in 0..4:
      if i < j:
        if dot(e(i), e(j))[0] != 0:
          raise newException(ValueError, "Unexpected non-null scalar product.")
      elif i == j:
        if dot(e(i), e(j))[0] == 0:
          raise newException(ValueError, "Unexpected null scalar product.")

  let a = randomMultiVector()
  let b = randomMultiVector()
  let c = randomMultiVector()
  let x = randomVector()

  # (ab)c == a(bc).
  echo (a * b) * c
  echo a * (b * c)
  echo()

  # a(b + c) == ab + ac.
  echo a * (b + c)
  echo a * b + a * c
  echo()

  # (a + b)c == ac + bc.
  echo (a + b) * c
  echo a * c + b * c
  echo()

  # x² is real.
  echo x * x
