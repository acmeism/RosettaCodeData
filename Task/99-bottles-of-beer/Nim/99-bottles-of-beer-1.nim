proc getBottleNumber(n: int): string =
  case n
  of 0:
    result = "No more bottles"
  of 1:
    result = "1 bottle"
  else:
    result = $n & " bottles"
  result &= " of beer"

for bn in countdown(99, 1):
  let cur = getBottleNumber(bn)
  echo(cur, " on the wall, ", cur, ".")
  echo("Take one down and pass it around, ", getBottleNumber(bn-1), " on the wall.\n")

echo "No more bottles of beer on the wall, no more bottles of beer."
echo "Go to the store and buy some more, 99 bottles of beer on the wall."
