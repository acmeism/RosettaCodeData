import random, sequtils, strutils

type
  Sample = tuple
    succ: int
    fail: int

const
  numPrisoners = 100
  numDrawsEachPrisoner = numPrisoners div 2
  numDrawings: Positive = 1_000_000 div 1

proc `$`(s: Sample): string =
  "Succs: $#\tFails: $#\tTotal: $#\tSuccess Rate: $#%." % [$s.succ, $s.fail, $(s.succ + s.fail), $(s.succ.float / (s.succ + s.fail).float * 100.0)]

proc prisonersWillBeReleasedSmart(): bool =
  result = true
  var drawers = toSeq(0..<numPrisoners)
  drawers.shuffle
  for prisoner in 0..<numPrisoners:
    var drawer = prisoner
    block inner:
      for _ in 0..<numDrawsEachPrisoner:
        if drawers[drawer] == prisoner: break inner
        drawer = drawers[drawer]
      return false

proc prisonersWillBeReleasedRandom(): bool =
  result = true
  var drawers = toSeq(0..<numPrisoners)
  drawers.shuffle
  for prisoner in 0..<numPrisoners:
    var selectDrawer = toSeq(0..<numPrisoners)
    selectDrawer.shuffle
    block inner:
      for i in 0..<numDrawsEachPrisoner:
        if drawers[selectDrawer[i]] == prisoner: break inner
      return false

proc massDrawings(prisonersWillBeReleased: proc(): bool): Sample =
  var success = 0
  for i in 1..numDrawings:
    if prisonersWillBeReleased():
      inc(success)
  return (success, numDrawings - success)

randomize()
echo $massDrawings(prisonersWillBeReleasedSmart)
echo $massDrawings(prisonersWillBeReleasedRandom)
