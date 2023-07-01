import strformat, strutils, threadpool

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


# Launch a thread for each number to process.
var responses: array[Numbers.len, FlowVar[int64]]
for i, n in Numbers:
  responses[i] = spawn lowestFactor(n)

# Read the results and find the largest minimum prime factor.
var maxMinfact = 0i64
var maxIdx: int
for i in 0..responses.high:
  let minfact = ^responses[i]   # Blocking read.
  echo &"For n = {Numbers[i]}, the lowest factor is {minfact}."
  if minfact > maxMinfact:
    maxMinfact = minfact
    maxIdx = i
let result = Numbers[maxIdx]

echo ""
echo "The first number with the largest minimum prime factor is: ", result
echo "Its factors are: ", result.factors(maxMinfact).join(", ")
