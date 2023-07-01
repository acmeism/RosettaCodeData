const max = 1000
var a: array[max, int]
for n in countup(0, max - 2):
  for m in countdown(n - 1, 0):
    if a[m] == a[n]:
      a[n + 1] = n - m
      break

echo "The first ten terms of the Van Eck sequence are:"
echo a[..9]
echo "\nTerms 991 to 1000 of the sequence are:"
echo a[990..^1]
