import sequtils, sets, strutils

iterator recaman(num: Positive = Natural.high): tuple[n, a: int; duplicate: bool] =
  var a = 0
  yield (0, a, false)
  var known = [0].toHashSet
  for n in 1..<num:
    var next = a - n
    if next <= 0 or next in known:
      next = a + n
    a = next
    yield (n, a, a in known)
    known.incl a

echo "First 15 numbers in Recaman’s sequence: ", toSeq(recaman(15)).mapIt(it.a).join(" ")

for (n, a, dup) in recaman():
  if dup:
    echo "First duplicate found: a($1) = $2".format(n, a)
    break

var target = toSeq(0..1000).toHashSet
for (n, a, dup) in recaman():
  target.excl a
  if target.card == 0:
    echo "All numbers from 0 to 1000 generated after $1 terms.".format(n)
    break
