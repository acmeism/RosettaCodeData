import bignum

# Missing functions in "bignum".

template isOdd(val: Int): bool =
  ## Needed as bignum "odd" function crashes.
  (val and 1) != 0

func exp(x, y, m: Int): Int =
  ## Missing "exp" function in "bignum".
  if m == 1: return newInt(0)
  result = newInt(1)
  var x = x mod m
  var y = y
  while y > 0:
    if y.isOdd:
      result = (result * x) mod m
    y = y shr 1
    x = (x * x) mod m


type Montgomery = object
  m: Int    # Modulus; must be odd.
  n: int    # m.bitLen().
  rrm: Int  # (1<<2n) mod m.

const Base = 2


func initMontgomery(m: Int): Montgomery =
  ## Initialize a Mongtgomery object.
  doAssert m > 0 and m.isOdd, "argument must be positive and odd."
  result.m = m
  result.n = m.bitLen
  result.rrm = newInt(1) shl culong(result.n * 2) mod m


func reduce(mont: Montgomery; t: Int): Int =
  ## Montgomery reduction algorithm.
  result = t
  for i in 0..<mont.n:
    if result.isOdd: inc result, mont.m
    result = result shr 1
  if result >= mont.m: dec result, mont.m


when isMainModule:

  let
    m = newInt("750791094644726559640638407699")
    x1 = newInt("540019781128412936473322405310")
    x2 = newInt("515692107665463680305819378593")

    mont = initMontgomery(m)
    t1 = x1 * mont.rrm
    t2 = x2 * mont.rrm

    r1 = mont.reduce(t1)
    r2 = mont.reduce(t2)
    r = newInt(1) shl culong(mont.n)

  echo "b:   ", Base
  echo "n:   ", mont.n
  echo "r:   ", r
  echo "m:   ", mont.m
  echo "t1:  ", t1
  echo "t2:  ", t2
  echo "r1:  ", r1
  echo "r2:  ", r2
  echo()
  echo "Original x1:       ", x1
  echo "Recovered from r1: ", mont.reduce(r1)
  echo "Original x2:       ", x2
  echo "Recovered from r2: ", mont.reduce(r2)

  echo "\nMontgomery computation of x1^x2 mod m:"
  var
    prod = mont.reduce(mont.rrm)
    base = mont.reduce(x1 * mont.rrm)
    e = x2
  while e > 0:
    if e.isOdd: prod = mont.reduce(prod * base)
    e = e shr 1
    base = mont.reduce(base * base)
  echo mont.reduce(prod)
  echo "\nAlternate computation of x1^x2 mod m:"
  echo x1.exp(x2, m)
