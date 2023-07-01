import sequtils, strutils

proc s1(n, k: Natural): Natural =
  if k == 0: return ord(n == 0)
  if k > n: return 0
  s1(n - 1, k - 1) + (n - 1) * s1(n - 1, k)

echo " k        ", toSeq(0..12).mapIt(($it).align(2)).join("        ")
echo " n"
for n in 0..12:
  stdout.write ($n).align(2)
  for k in 0..n:
    stdout.write ($s1(n, k)).align(10)
  stdout.write '\n'
