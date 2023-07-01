import algorithm
import sequtils
import strutils
import tables

const PrimeProg = "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"

type
  Fraction = tuple[num, denom: int]
  Factors = Table[int, int]
  FractranProg = object
    primes: seq[int]
    nums, denoms: seq[Factors]
    exponents: seq[int]   # Could also use a CountTable.

iterator fractions(fractString: string): Fraction =
  ## Extract fractions from a string and yield them.
  for f in fractString.split():
    let fields = f.strip().split('/')
    assert fields.len == 2
    yield (fields[0].parseInt(), fields[1].parseInt())

iterator factors(val: int): tuple[val, exp: int] =
  ## Extract factors from a positive integer.

  # Extract factor 2.
  var val = val
  var exp = 0
  while (val and 1) == 0:
    inc exp
    val = val shr 1
  if exp != 0:
    yield (2, exp)

  # Extract odd factors.
  var d = 3
  while d <= val:
    exp = 0
    while val mod d == 0:
      inc exp
      val = val div d
    if exp != 0:
      yield (d, exp)
    inc d, 2

func newProg(fractString: string; init: int): FractranProg =
  ## Initialize a Fractran program.

  for f in fractString.fractions():
    # Extract numerators factors.
    var facts: Factors
    for (val, exp) in f.num.factors():
      result.primes.add(val)
      facts[val] = exp
    result.nums.add(facts)
    # Extract denominator factors.
    facts.clear()
    for (val, exp) in f.denom.factors():
      result.primes.add(val)
      facts[val] = exp
    result.denoms.add(facts)

    # Finalize list of primes.
    result.primes.sort()
    result.primes = result.primes.deduplicate(true)

    # Allocate and initialize exponent sequence.
    result.exponents.setLen(result.primes[^1] + 1)
    for (val, exp) in init.factors():
      result.exponents[val] = exp

func doOneStep(prog: var FractranProg): bool =
  ## Execute one step of the program.

  for idx, factor in prog.denoms:
    block tryFraction:
      for val, exp in factor.pairs():
        if prog.exponents[val] < exp:
          # Not a multiple of the denominator.
          break tryFraction
      # Divide by the denominator.
      for val, exp in factor.pairs():
        dec prog.exponents[val], exp
      # Multiply by the numerator.
      for val, exp in prog.nums[idx]:
        inc prog.exponents[val], exp
      return true

func `$`(prog: FractranProg): string =
  ## Display a value as a product of prime factors.

  for val, exp in prog.exponents:
    if exp != 0:
      if result.len > 0:
        result.add('.')
      result.add($val)
      if exp > 1:
        result.add('^')
        result.add($exp)

proc run(fractString: string; init: int; maxSteps = 0) =
  ## Run a Fractran program.

  var prog = newProg(fractString, init)

  var stepCount = 0
  while stepCount < maxSteps:
    if not prog.doOneStep():
      echo "*** No more possible fraction. Program stopped."
      return
    inc stepCount
    echo stepCount, ": ", prog

proc findPrimes(maxCount: int) =
  ## Search and print primes.

  var prog = newProg(PrimeProg, 2)
  let oddPrimes = prog.primes[1..^1]
  var primeCount = 0
  while primeCount < maxCount:
    discard prog.doOneStep()
    block powerOf2:
      if prog.exponents[2] > 0:
        for p in oddPrimes:
          if prog.exponents[p] != 0:
            # Not a power of 2.
            break powerOf2
        inc primeCount
        echo primeCount, ": ", prog.exponents[2]

#------------------------------------------------------------------------------

echo "First ten steps for program to find primes:"
run(PrimeProg, 2, 10)
echo "\nFirst twenty prime numbers:"
findPrimes(20)
