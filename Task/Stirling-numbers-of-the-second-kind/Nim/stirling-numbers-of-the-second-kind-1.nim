import sequtils, strutils

proc s2(n, k: Natural): Natural =
  if n == k: return 1
  if n == 0 or k == 0: return 0
  k * s2(n - 1, k) + s2(n - 1, k - 1)

echo " k      ", toSeq(0..12).mapIt(($it).align(2)).join("      ")
echo " n"
for n in 0..12:
  stdout.write ($n).align(2)
  for k in 0..n:
    stdout.write ($s2(n, k)).align(8)
  stdout.write '\n'
