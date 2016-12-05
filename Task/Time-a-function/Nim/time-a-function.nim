import times, os

proc doWork(x) =
  var n = x
  for i in 0..10000000:
    n += i
  echo n

template time(s: stmt): expr =
  let t0 = cpuTime()
  s
  cpuTime() - t0

echo time(doWork(100))
