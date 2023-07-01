import algorithm, math, sequtils, strformat, strutils, sugar

const Pow10 = collect(newSeq, for n in 0..18: 10 ^ n)

template isOdd(n: int): bool = (n and 1) != 0

proc fangs(n: Positive): seq[(int, int)] =
  ## Return the list fo fangs of "n" (empty if "n" is not vampiric).
  let nDigits = sorted($n)
  if nDigits.len.isOdd: return @[]
  let fangLen = nDigits.len div 2
  let inf = Pow10[fangLen - 1]
  let sup = inf * 10 - 1
  for d in inf..sup:
    if n mod d != 0: continue
    let q = n div d
    if q < d: return
    let dDigits = $d
    let qDigits = $q
    if qDigits.len > fangLen: continue
    if qDigits.len < fangLen: return
    if nDigits != sorted(dDigits & qDigits): continue
    if dDigits[^1] != '0' or qDigits[^1] != '0':
      # Finally, "n" is vampiric. Add the fangs to the result.
      result.add (d, q)


echo "First 25 vampire numbers with their fangs:"
var count = 0
var n = 10
var limit = 100
while count != 25:
  let fangList = n.fangs
  if fangList.len != 0:
    inc count
    echo &"{count:2}: {n:>6} = ", fangList.mapIt(&"{it[0]:3} × {it[1]:3}").join(" = ")
  inc n
  if n == limit:
    n *= 10
    limit *= 10

echo()
for n in [16_758_243_290_880, 24_959_017_348_650, 14_593_825_548_650]:
  let fangList = n.fangs
  if fangList.len == 0:
    echo &"{n} is not vampiric."
  else:
    echo &"{n} = ", fangList.mapIt(&"{it[0]} × {it[1]}").join(" = ")
