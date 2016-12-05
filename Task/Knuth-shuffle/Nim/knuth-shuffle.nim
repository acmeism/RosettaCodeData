import math
randomize()

proc shuffle[T](x: var seq[T]) =
  for i in countdown(x.high, 0):
    let j = random(i + 1)
    swap(x[i], x[j])

var x = @[0,1,2,3,4,5,6,7,8,9]
shuffle(x)
echo x
