import times, strutils

const
  MaxLen = 13
  MaxNonBrauer = 382

func isBrauer(a: seq[int]): bool =
  for i in 2..a.high:
    block loop:
      for j in countdown(i - 1, 0):
        if a[i-1] + a[j] == a[i]:
          break loop
      return false
  result = true

var
  brauerCount, nonBrauerCount: int
  brauerExample, nonBrauerExample: seq[int]


proc additionChains(target, length: int; chosen: seq[int]): int =
  var length = length
  var le = chosen.len
  var last = chosen[^1]

  if last == target:
    if le < length:
      brauerCount = 0
      nonBrauerCount = 0
    if chosen.isBrauer:
      inc brauerCount
      brauerExample = chosen
    else:
      inc nonBrauerCount
      nonBrauerExample = chosen
    return le

  if le == length: return length

  if target > MaxNonBrauer:
    var nextChosen = chosen & 0
    for i in countdown(le - 1, 0):
      let next = last + chosen[i]
      if next <= target and next > chosen[^1] and i < length:
        nextChosen[^1] = next
        length = additionChains(target, length, nextChosen)
  else:
    var ndone = newSeqOfCap[int](le)
    var nextChosen = chosen & 0
    while true:
      for i in countdown(le - 1, 0):
        let next = last + chosen[i]
        if next <= target and next > chosen[^1] and i < length and next notin ndone:
          ndone.add next
          nextChosen[^1] = next
          length = additionChains(target, length, nextChosen)
      dec le
      if le == 0: break
      last = chosen[le-1]
  result = length


const Nums = [7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379]

let start = now()
echo "Searching for Brauer chains up to a minimum length of ", MaxLen - 1
for num in Nums:
  brauerCount = 0
  nonBrauerCount = 0
  let le = additionChains(num, MaxLen, @[1])
  echo "\nN = ", num
  echo "Minimum length of chains : L($1) = $2".format(num, le - 1)
  echo "Number of minimum length Brauer chains: ", brauerCount
  if brauerCount > 0:
    echo "Brauer example: ", brauerExample.join(", ")
  echo "Number of minimum length non-Brauer chains: ", nonBrauerCount
  if nonBrauerCount > 0:
    echo "Non-Brauer example: ", nonBrauerExample.join(", ")
echo "\nTook ", now() - start
