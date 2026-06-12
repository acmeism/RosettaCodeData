import std/[algorithm, math, strformat]
import gnuplot

type IntComplex = tuple[re, im: int]

func isPrime(n: Natural): bool =
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  var d = 3
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, 2
  result = true

func norm(c: IntComplex): Natural =
  c.re * c.re + c.im * c.im

func `$`(c: IntComplex): string =
  if c.im == 0: return $c.re
  if c.re == 0: return $c.im & 'i'
  let op = if c.im > 0: '+' else: '-'
  result = &"{c.re}{op}{abs(c.im)}i"

func isGaussianPrime(c: IntComplex): bool =
  if c.re == 0:
    let x = abs(c.im)
    return x.isPrime and (x and 3) == 3
  if c.im == 0:
    let x = abs(c.re)
    return x.isPrime and (x and 3) == 3
  result = c.norm.isPrime

func gaussianPrimes(maxNorm: Positive): seq[IntComplex] =
  var gpList: seq[IntComplex]
  let m = sqrt(maxNorm.toFloat).int
  for x in -m..m:
    for y in -m..m:
      let c = (x, y)
      if c.norm < maxNorm and c.isGaussianPrime:
        gpList.add c
  result = gpList.sortedByIt(it.norm)

echo "Gaussian primes with a norm less than 100 sorted by norm:"
for i, gp in gaussianPrimes(100):
  stdout.write &"{gp:>5}"
  stdout.write if i mod 10 == 9: '\n' else: ' '

var x, y: seq[int]
for gp in gaussianPrimes(150^2):
  x.add gp.re
  y.add gp.im

withGnuPlot:
  cmd "set size ratio -1"
  plot(x, y, "Gaussian primes", "with dots lw 2")
