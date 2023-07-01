import sequtils
import bignum

proc sylverster(lim: Positive): seq[Int] =
  result.add(newInt(2))
  for _ in 2..lim:
    result.add result.foldl(a * b) + 1

let list = sylverster(10)
echo "First 10 terms of the Sylvester sequence:"
for item in list: echo item

var sum = newRat()
for item in list: sum += newRat(1, item)
echo "\nSum of the reciprocals of the first 10 terms: ", sum.toFloat
