import deques

proc simplemovingaverage(period: int): auto =
  assert period > 0

  var
    summ, n = 0.0
    values: Deque[float]
  for i in 1..period:
    values.addLast(0)

  proc sma(x: float): float =
    values.addLast(x)
    summ += x - values.popFirst()
    n = min(n+1, float(period))
    result = summ / n

  return sma

var sma = simplemovingaverage(3)
for i in 1..5: echo sma(float(i))
for i in countdown(5,1): echo sma(float(i))

echo ""

var sma2 = simplemovingaverage(5)
for i in 1..5: echo sma2(float(i))
for i in countdown(5,1): echo sma2(float(i))
