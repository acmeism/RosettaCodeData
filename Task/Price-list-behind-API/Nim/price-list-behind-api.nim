import math, strformat

const MinDelta = 1.0

type Result = tuple[min, max: float; count: int]


func getPRangeCount(prices: seq[float]; min, max: float): int =
  for price in prices:
    if price in min..max:
      inc result


func get5000(prices: seq[float]; min, max: float; n: int): (float, int) =
    var
      count = prices.getPRangeCount(min, max)
      delta = (max - min) / 2
      max = max
    while count != n and delta >= MinDelta / 2:
      if count > n: max -= delta
      else: max += delta
      max = floor(max)
      count = getPRangeCount(prices, min, max)
      delta /= 2
    result = (max, count)


func getAll5000(prices: seq[float]; min, max: float; n: int): seq[Result] =
    var (pmax, pcount) = prices.get5000(min, max, n)
    result = @[(min, pmax, pcount)]
    while pmax < max:
      let pmin = pmax + 1
      (pmax, pcount) = prices.get5000(pmin, max, n)
      if pcount == 0:
        raise newException(ValueError, &"Price list from {pmin} has too many with same price.")
      result.add (pmin, pmax, pcount)


when isMainModule:
  import random, sequtils
  randomize()

  let numPrices = rand(99_000..101_000)
  const MaxPrice = 100_000
  let prices = newSeqWith(numPrices, rand(1..MaxPrice).toFloat)
  let actualMax = max(prices)
  echo &"Using {numPrices} items with prices from 0 to {actualMax.int}:"

  let res = prices.getAll5000(0, actualMax, 5000)
  echo &"Split into {res.len} bins of approx 5000 elements:"
  var total = 0
  for (minf, maxf, count) in res:
    let min = minf.toInt
    let max = min(maxf, actualMax).toInt
    inc total, count
    echo &"   From {min:6} to {max:6} with {count:4} items"

  if total != numPrices:
    echo &"Something went wrong: grand total of {total} doesn't equal {numPrices}!"
