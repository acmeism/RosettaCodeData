import math, strformat

func juggler(n: Positive): tuple[count: int; max: uint64; maxIdx: int] =
  var a = n.uint64
  result = (0, a, 0)
  while a != 1:
    let f = float(a)
    a = if (a and 1) == 0: sqrt(f).uint64
        else: uint64(f * sqrt(f))
    inc result.count
    if a > result.max:
      result.max = a
      result.maxIdx = result.count

echo "n   l[n]            h[n]  i[n]"
echo "——————————————————————————————"
for n in 20..39:
  let (l, h, i) = juggler(n)
  echo &"{n}   {l:2}  {h:14}     {i}"
