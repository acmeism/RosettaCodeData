import math, sequtils, strutils

var
  supply = [50, 60, 50, 50]
  demand = [30, 20, 70, 30, 60]

let
  costs = [[16, 16, 13, 22, 17],
           [14, 14, 13, 19, 15],
           [19, 19, 20, 23, 50],
           [50, 12, 50, 15, 11]]

  nRows = supply.len
  nCols = demand.len

var
  rowDone = newSeq[bool](nRows)
  colDone = newSeq[bool](nCols)
  results = newSeqWith(nRows, newSeq[int](nCols))


proc diff(j, len: int; isRow: bool): array[3, int] =
  var min1, min2 = int.high
  var minP = -1
  for i in 0..<len:
    let done = if isRow: colDone[i] else: rowDone[i]
    if done: continue
    let c = if isRow: costs[j][i] else: costs[i][j]
    if c < min1:
      min2 = min1
      min1 = c
      minP = i
    elif c < min2:
      min2 = c
  result = [min2 - min1, min1, minP]


proc maxPenalty(len1, len2: int; isRow: bool): array[4, int] =
  var md = int.low
  var pc, pm, mc = -1
  for i in 0..<len1:
    let done = if isRow: rowDone[i] else: colDone[i]
    if done: continue
    let res = diff(i, len2, isRow)
    if res[0] > md:
      md = res[0]  # max diff
      pm = i       # pos of max diff
      mc = res[1]  # min cost
      pc = res[2]  # pos of min cost
  result = if isRow: [pm, pc, mc, md] else: [pc, pm, mc, md]


proc nextCell(): array[4, int] =
  let res1 = maxPenalty(nRows, nCols, true)
  let res2 = maxPenalty(nCols, nRows, false)
  if res1[3] == res2[3]:
    return if res1[2] < res2[2]: res1 else: res2
  result = if res1[3] > res2[3]: res2 else: res1


when isMainModule:

  var supplyLeft = sum(supply)
  var totalCost = 0

  while supplyLeft > 0:
    let cell = nextCell()
    let r = cell[0]
    let c = cell[1]
    let q = min(demand[c], supply[r])
    dec demand[c], q
    if demand[c] == 0: colDone[c] = true
    dec supply[r], q
    if supply[r] == 0: rowDone[r] = true
    results[r][c] = q
    dec supplyLeft, q
    inc totalCost, q * costs[r][c]

  echo "    A   B   C   D   E"
  for i, result in results:
    stdout.write chr(i + ord('W'))
    for item in result:
      stdout.write "  ", ($item).align(2)
    echo()
  echo "\nTotal cost = ", totalCost
