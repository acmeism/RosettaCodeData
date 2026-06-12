import std/[algorithm, complex, math, strformat]

import gnuplot

func isPrime(n: Natural): bool =
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  var delta = 2
  while k * k <= n:
    if n mod k == 0: return false
    inc k, delta
    delta = 6 - delta
  result = true


### Eisenstein definition.

const ω = complex(-0.5, sqrt(3.0) * 0.5)

type Eisenstein = object
  a: int
  b: int
  n: Complex64

func initEisenstein(a, b: int): Eisenstein =
  ## Initialize an Eisenstein number.
  Eisenstein(a: a, b: b, n: a.toFloat + b.toFloat * ω)

template re(e: Eisenstein): float = e.n.re
template im(e: Eisenstein): float = e.n.im

func norm(e: Eisenstein): int =
  ## return the norm of an Eisenstein number.
  e.a * e.a - e.a * e.b + e.b * e.b

func isPrime(e: Eisenstein): bool =
  ## Return true if an Eisenstein number is prime.
  if e.a == 0 or e.b == 0 or e.a == e.b:
    let c = max(abs(e.a), abs(e.b))
    result = c.isPrime and c mod 3 == 2
  else:
    result = e.norm.isPrime

func `$`(e: Eisenstein): string =
  ## Return a string representation of an Eisenstein number.
  let (sign, im) = if e.im >= 0: ('+', e.im) else: ('-', -e.im)
  result =  &"{e.re:7.4f} {sign} {im:6.4f}i"


### Find Eisenstein primes.

var eprimes: seq[Eisenstein]
for a in -100..100:
  for b in -100..100:
    let e = initEisenstein(a, b)
    if e.isPrime: eprimes.add e

# Try to replicate Wren sort order for easy comparison.
eprimes.sort(proc (e1, e2: Eisenstein): int =
               result = cmp(e1.norm, e2.norm)
               if result == 0:
                 result = cmp(e1.im, e2.im)
                 if result == 0:
                   result = cmp(e1.re, e2.re)
            )

# Display first 100 Eisenstein primes to terminal.
echo "First 100 Eisenstein primes nearest zero:"
for i in 0..99:
  stdout.write eprimes[i]
  stdout.write if i mod 4 == 3: "\n" else: "  "

# Generate points for the plot.
var x, y: seq[float]
for e in eprimes:
  x.add e.re
  y.add e.im

withGnuPlot:
  cmd "set size ratio -1"
  plot(x, y, "Eisenstein primes", "with dots lw 2")
