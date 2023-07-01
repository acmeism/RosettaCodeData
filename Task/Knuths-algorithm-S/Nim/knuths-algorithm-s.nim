import random

func sOfNCreator[T](n: Positive): proc(item: T): seq[T] =
  var sample = newSeqOfCap[T](n)
  var i = 0

  result = proc(item: T): seq[T] =
             inc i
             if i <= n:
               sample.add(item)
             elif rand(1..i) <= n:
               sample[rand(n - 1)] = item
             sample

when isMainModule:

  randomize()

  echo "Digits counts for 100_000 runs:"
  var hist: array[10, Natural]
  for _ in 1..100_000:
    let sOfN = sOfNCreator[Natural](3)
    for i in 0..8:
      discard sOfN(i)
    for val in sOfN(9):
      inc hist[val]

  for n, count in hist:
    echo n, ": ", count
