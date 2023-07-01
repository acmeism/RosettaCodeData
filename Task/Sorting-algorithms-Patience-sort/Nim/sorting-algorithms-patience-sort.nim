import std/decls

func patienceSort[T](a: var openArray[T]) =

  if a.len < 2: return

  var piles: seq[seq[T]]

  for elem in a:
    block processElem:
      for pile in piles.mitems:
        if pile[^1] > elem:
          pile.add(elem)
          break processElem
      piles.add(@[elem])

  for i in 0..a.high:
    var min = piles[0][^1]
    var minPileIndex = 0
    for j in 1..piles.high:
      if piles[j][^1] < min:
        min = piles[j][^1]
        minPileIndex = j

    a[i] = min
    var minPile {.byAddr.} = piles[minPileIndex]
    minPile.setLen(minpile.len - 1)
    if minPile.len == 0: piles.delete(minPileIndex)


when isMainModule:

  var iArray = [4, 65, 2, -31, 0, 99, 83, 782, 1]
  iArray.patienceSort()
  echo iArray
  var cArray = ['n', 'o', 'n', 'z', 'e', 'r', 'o', 's', 'u','m']
  cArray.patienceSort()
  echo cArray
  var sArray = ["dog", "cow", "cat", "ape", "ant", "man", "pig", "ass", "gnu"]
  sArray.patienceSort()
  echo sArray
