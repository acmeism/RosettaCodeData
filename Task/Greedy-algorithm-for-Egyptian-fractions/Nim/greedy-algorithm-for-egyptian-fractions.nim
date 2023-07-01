import strformat, strutils
import bignum

let
  Zero = newInt(0)
  One = newInt(1)

#---------------------------------------------------------------------------------------------------

proc toEgyptianrecursive(rat: Rat; fracs: seq[Rat]): seq[Rat] =

  if rat.isZero: return fracs

  let iquo = cdiv(rat.denom, rat.num)
  let rquo = newRat(1, iquo)
  result = fracs & rquo
  let num2 = cmod(-rat.denom, rat.num)
  if num2 < Zero:
    num2 += rat.num
  let denom2 = rat.denom * iquo
  let f = newRat(num2, denom2)
  if f.num == One:
    result.add(f)
  else:
    result = f.toEgyptianrecursive(result)

#---------------------------------------------------------------------------------------------------

proc toEgyptian(rat: Rat): seq[Rat] =

  if rat.num.isZero: return @[rat]

  if abs(rat.num) >= rat.denom:
    let iquo = rat.num div rat.denom
    let rquo = newRat(iquo, 1)
    let rrem = rat - rquo
    result = rrem.toEgyptianrecursive(@[rquo])
  else:
    result = rat.toEgyptianrecursive(@[])

#———————————————————————————————————————————————————————————————————————————————————————————————————

for frac in [newRat(43, 48), newRat(5, 121), newRat(2014, 59)]:
  let list = frac.toEgyptian()
  if list[0].denom == One:
    let first = fmt"[{list[0].num}]"
    let rest = list[1..^1].join(" + ")
    echo fmt"{frac} -> {first} + {rest}"
  else:
    let all = list.join(" + ")
    echo fmt"{frac} -> {all}"

for r in [98, 998]:
  if r == 98:
    echo "\nFor proper fractions with 1 or 2 digits:"
  else:
    echo "\nFor proper fractions with 1, 2 or 3 digits:"

  var maxSize = 0
  var maxSizeFracs: seq[Rat]
  var maxDen = Zero
  var maxDenFracs: seq[Rat]
  var sieve = newSeq[seq[bool]](r + 1)  # To eliminate duplicates.

  for item in sieve.mitems: item.setLen(r + 2)
  for i in 1..r:
    for j in (i + 1)..(r + 1):
      if sieve[i][j]: continue

      let f = newRat(i, j)
      let list = f.toEgyptian()
      let listSize = list.len
      if listSize > maxSize:
        maxSize = listSize
        maxSizeFracs.setLen(0)
        maxSizeFracs.add(f)
      elif listSize == maxSize:
        maxSizeFracs.add(f)

      let listDen = list[^1].denom()
      if listDen > maxDen:
        maxDen = listDen
        maxDenFracs.setLen(0)
        maxDenFracs.add(f)
      elif listDen == maxDen:
        maxDenFracs.add(f)

      if i < r div 2:
        var k = 2
        while j * k <= r + 1:
          sieve[i * k][j * k] = true
          inc k

  echo fmt"  largest number of items = {maxSize}"
  echo fmt"  fraction(s) with this number : {maxSizeFracs.join("", "")}"
  let md = $maxDen
  echo fmt"  largest denominator = {md.len} digits, {md[0..19]}...{md[^20..^1]}"
  echo fmt"  fraction(s) with this denominator : {maxDenFracs.join("", "")}"
