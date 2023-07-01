import algorithm, math, strformat

const Alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"


func toBaseN(num, base: Natural): string =
  doAssert(base in 2..Alphabet.len, &"base must be in 2..{Alphabet.len}")
  var num = num
  while true:
    result.add(Alphabet[num mod base])
    num = num div base
    if num == 0: break
  result.reverse()


func countUnique(str: string): int =
  var charset: set['0'..'Z']
  for ch in str: charset.incl(ch)
  result = charset.card


proc find(base: Natural) =
  var n = pow(base.toFloat, (base - 1) / 2).int
  while true:
    let sq = n * n
    let sqstr = sq.toBaseN(base)
    if sqstr.len >= base and countUnique(sqstr) == base:
      let nstr = n.toBaseN(base)
      echo &"Base {base:2d}:  {nstr:>8s}² = {sqstr:<16s}"
      break
    inc n


when isMainModule:
  for base in 2..16:
    base.find()
