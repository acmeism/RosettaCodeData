import math, sequtils, strutils

type Solver = object
  want: Positive
  count1: Natural
  count2: Natural
  width: Natural

proc count(solver: var Solver; sum: int; used, have, uindices, rindices: seq[int]) =
  if sum == solver.want:
    inc solver.count1
    inc solver.count2, fac(used.len)
    if solver.count1 < 11:
      let uindiceStr = ($uindices.join(" ")).alignLeft(solver.width)
      echo "  indices $1  →  used $2".format(uindiceStr, used.join(" "))
  elif sum < solver.want and have.len != 0:
    let thisCoin = have[0]
    let index = rindices[0]
    let rest = have[1..^1]
    let rindices = rindices[1..^1]
    solver.count(sum + thisCoin, used & thisCoin, rest, uindices & index, rindices)
    solver.count(sum, used, rest, uindices, rindices)

proc countCoins(want: int; coins: openArray[int]; width: int) =
  echo "Sum $# from coins $#".format(want, coins.join(" "))
  var solver = Solver(want: want, width: width)
  var rindices = toSeq(0..coins.high)
  solver.count(0, newSeq[int](), @coins, newSeq[int](), rindices)
  if solver.count1 > 10:
    echo "  ......."
    echo "  (only the first 10 ways generated are shown)"
  echo "Number of ways – order unimportant : ", solver.count1, " (as above)"
  echo "Number of ways – order important   : ", solver.count2, " (all perms of above indices)\n"

when isMainModule:
  countCoins(6, [1, 2, 3, 4, 5], 5)
  countCoins(6, [1, 1, 2, 3, 3, 4, 5], 7)
  countCoins(40, [1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100], 18)
