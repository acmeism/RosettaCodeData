import sequtils, strutils, threadpool

{.experimental: "parallel".}

const Numbers = [576460752303423487,
                 576460752303423487,
                 576460752303423487,
                 112272537195293,
                 115284584522153,
                 115280098190773,
                 115797840077099,
                 112582718962171,
                 299866111963290359]


proc lowestFactor(n: int64): int64 =
  if n mod 2 == 0: return 2
  if n mod 3 == 0: return 3
  var p = 5
  var delta = 2
  while p * p < n:
    if n mod p == 0: return p
    inc p, delta
    delta = 6 - delta
  result = n


proc factors(n, lowest: int64): seq[int64] =
  var n = n
  var lowest = lowest
  while true:
    result.add lowest
    n = n div lowest
    if n == 1: break
    lowest = lowestFactor(n)


# Launch the threads.
var results: array[Numbers.len, int64]    # To store the results.
parallel:
  for i, n in Numbers:
    results[i] = spawn lowestFactor(n)

# Find the minimum prime factor and the first number with this minimum factor.
let maxIdx = results.maxIndex()
let maxMinfact = results[maxIdx]
let result = Numbers[maxIdx]

echo ""
echo "The first number with the largest minimum prime factor is: ", result
echo "Its factors are: ", result.factors(maxMinfact).join(", ")
