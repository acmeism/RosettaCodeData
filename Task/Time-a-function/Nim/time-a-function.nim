import times, strutils

proc doWork(x: int) =
  var n = x
  for i in 0..10000000:
    n += i

template time(statement: untyped): float =
  let t0 = cpuTime()
  statement
  cpuTime() - t0

echo "Time = ", time(doWork(100)).formatFloat(ffDecimal, precision = 3), " s"
