import std/[math, strutils]

const
  Sequences = {"Catalan":
                 [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440],
               "Prime flip-flop":
                 [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0],
               "Fibonacci":
                 [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377],
               "Padovan":
                 [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9]}

func binomialTransform(a: openArray[int]): seq[int] =
  for n in 0..a.high:
    var val = 0
    for k in 0..n:
      val += binom(n, k) * a[k]
    result.add val

func invBinomialSequence(b: openArray[int]): seq[int] =
  for n in 0..b.high:
    var val = 0
    var sign = ord((n and 1) == 0) shl 1 - 1
    for k in 0..n:
      val += binom(n, k) * b[k] * sign
      sign = -sign
    result.add val

for (name, sequence) in Sequences:
  echo name, " sequence:"
  echo sequence.join(" ")
  let forward = binomialTransform(sequence)
  echo "Forward binomial transform:"
  echo forward.join(" ")
  echo "Inverse binomial transform:"
  let inverse = invBinomialSequence(sequence)
  echo inverse.join(" ")
  echo "Inverse of the forward transform:"
  let invForward = invBinomialSequence(forward)
  echo invForward.join(" ")
  echo()
