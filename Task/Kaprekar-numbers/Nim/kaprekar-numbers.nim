import strutils, sequtils

proc k(n: int): bool =
  let n2 = $(n.int64 * n)
  for i in 0 .. n2.high:
    let a = if i > 0: parseBiggestInt n2[0 ..< i] else: 0
    let b = parseBiggestInt n2[i .. n2.high]
    if b > 0 and a + b == n:
      return true

echo toSeq(1..10_000).filter(k)
echo len toSeq(1..1_000_000).filter(k)
