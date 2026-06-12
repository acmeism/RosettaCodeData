import std/sums

# "std/sums" proposes the "sumKbn" function which uses the
# Kahan-Babuška-Neumaier algorithm, an improvement of Kahan algorithm.

func kahanSum[T](input: openArray[T]): T =
  var c = T(0)
  for val in input:
    let y = val - c
    let t = result + y
    c = (t - result) - y
    result = t

template isOne[T](n: T): string =
  if n == 1: "yes" else: "no"

var epsilon = 1.0
while 1 + epsilon != 1:
    epsilon = epsilon / 2

let a = 1.0
let b = epsilon
let c = -epsilon

echo "Computing sum of 1.0, epsilon and -epsilon for epsilon = ", epsilon, '.'
echo "Is result equal to 1.0?"
echo "- simple addition: ", (a + b + c).isOne
echo "- using Kahan sum: ",  kahanSum([a, b, c]).isOne
echo "- using stdlib:    ", sumKbn([a, b, c]).isOne
