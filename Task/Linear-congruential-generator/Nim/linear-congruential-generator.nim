proc bsdRand(seed: int): iterator: int =
  var state = seed
  result = iterator: int =
    while true:
      state = (1_103_515_245 * state + 12_345) and 0x7fffffff
      yield state

proc msvcrtRand(seed: int): iterator: int =
  var state = seed
  result = iterator: int =
    while true:
      state = (214_013 * state + 2_531_011) and 0x7fffffff
      yield state shr 16

echo "BSD with seed = 1 (OEIS A096553):"
var count = 0
let iter1 = bsdRand(1)
for val in iter1():
  echo val
  inc count
  if count == 10:
    break

echo ""
echo "Microsoft with seed = 0 (OEIS A096558):"
count = 0
let iter2 = msvcrtRand(0)
for val in iter2():
  echo val
  inc count
  if count == 10:
    break
