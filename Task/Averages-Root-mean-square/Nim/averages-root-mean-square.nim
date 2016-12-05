import math

proc qmean(num): float =
  for n in num:
    result += n*n
  result = sqrt(result / float(num.len))

echo qmean([1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0])
