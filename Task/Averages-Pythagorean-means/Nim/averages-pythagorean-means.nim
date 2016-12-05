import math, sequtils, future

proc amean(num): float =
  sum(num) / float(len(num))

proc gmean(num): float =
  result = 1
  for n in num: result *= n
  result = pow(result, 1.0 / float(num.len))

proc hmean(num): float =
  for n in num: result += 1.0 / n
  result = float(num.len) / result

proc ameanFunctional(num: seq[float]): float =
  sum(num) / float(num.len)

proc gmeanFunctional(num: seq[float]): float =
  num.foldl(a * b).pow(1.0 / float(num.len))

proc hmeanFunctional(num: seq[float]): float =
  float(num.len) / sum(num.mapIt(float, 1.0 / it))

let numbers = toSeq(1..10).map((x: int) => float(x))
echo amean(numbers), " ", gmean(numbers), " ", hmean(numbers)
