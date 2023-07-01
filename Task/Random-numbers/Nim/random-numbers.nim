import random, stats, strformat

var rs: RunningStat

randomize()

for _ in 1..5:
  for _ in 1..1000: rs.push gauss(1.0, 0.5)
  echo &"mean: {rs.mean:.5f}    stdDev: {rs.standardDeviation:.5f}"
