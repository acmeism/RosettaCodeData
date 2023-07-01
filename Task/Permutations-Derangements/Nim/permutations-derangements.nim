import algorithm, sequtils, strformat, strutils, tables

iterator derangements[T](a: openArray[T]): seq[T] =
  var perm = @a
  while true:
    if not perm.nextPermutation():
      break
    block checkDerangement:
      for i, val in a:
        if perm[i] == val: break checkDerangement
      yield perm

proc `!`(n: Natural): Natural =
  if n <= 1: return 1 - n
  result = (n - 1) * (!(n - 1) + !(n - 2))

echo "Derangements of 1 2 3 4:"
for d in [1, 2, 3, 4].derangements():
  echo d.join(" ")

echo "\nNumber of derangements:"
echo "n   counted   calculated"
echo "-   -------   ----------"
for n in 0..9:
  echo &"{n}   {toSeq(derangements(toSeq(1..n))).len:>6}      {!n:>6}"

echo "\n!20 = ", !20
