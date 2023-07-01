import random
randomize()

proc shuffle[T](x: var openArray[T]) =
  for i in countdown(x.high, 1):
    let j = rand(i)
    swap(x[i], x[j])

var x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
shuffle(x)
echo x
