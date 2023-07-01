import algorithm, sequtils, strutils

proc levenshteinAlign(a, b: string): tuple[a, b: string] =
  let a = a.toLower()
  let b = b.toLower()
  var costs = newSeqWith(a.len + 1, newSeq[int](b.len + 1))
  for j in 0..b.len: costs[0][j] = j
  for i in 1..a.len:
    costs[i][0] = i
    for j in 1..b.len:
      let tmp = costs[i - 1][j - 1] + ord(a[i - 1] != b[j - 1])
      costs[i][j] = min(1 + min(costs[i - 1][j], costs[i][j - 1]), tmp)

  # Walk back through matrix to figure out path.
  var aPathRev, bPathRev: string
  var i = a.len
  var j = b.len
  while i != 0 and j != 0:
    let tmp = costs[i - 1][j - 1] + ord(a[i - 1] != b[j - 1])
    if costs[i][j] == tmp:
      dec i
      dec j
      aPathRev.add a[i]
      bPathRev.add b[j]
    elif costs[i][j] == 1 + costs[i-1][j]:
      dec i
      aPathRev.add a[i]
      bPathRev.add '-'
    elif costs[i][j] == 1 + costs[i][j-1]:
      dec j
      aPathRev.add '-'
      bPathRev.add b[j]
    else:
      quit "Internal error"

  result = (reversed(aPathRev).join(), reversed(bPathRev).join())

when isMainModule:

  var result = levenshteinAlign("place", "palace")
  echo result.a
  echo result.b
  echo ""

  result = levenshteinAlign("rosettacode","raisethysword")
  echo result.a
  echo result.b
