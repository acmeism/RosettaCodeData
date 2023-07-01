import random, strformat

const T = 100

var
  pList = [0.1, 0.3, 0.5, 0.7, 0.9]
  nList = [100, 1_000, 10_000, 100_000]

for p in pList:

  let theory = p * (1 - p)
  echo &"\np: {p:.4f}  theory: {theory:.4f}  t: {T}"
  echo "        n          sim     sim-theory"

  for n in nList:
    var sum = 0
    for _ in 1..T:
      var run = false
      for _ in 1..n:
        let one = rand(1.0) < p
        if one and not run: inc sum
        run = one

    let k = sum / (T * n)
    echo &"{n:9} {k:15.4f} {k - theory:10.6f}"
