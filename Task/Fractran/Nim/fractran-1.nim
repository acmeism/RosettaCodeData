import strutils
import bignum

const PrimeProg = "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"

iterator values(prog: openArray[Rat]; init: Natural): Int =
  ## Run the program "prog" with initial value "init" and yield the values.
  var n = newInt(init)
  var next: Rat
  while true:
    for fraction in prog:
      next = n * fraction
      if next.denom == 1:
        break
    n = next.num
    yield n

func toFractions(fractList: string): seq[Rat] =
  ## Convert a string to a list of fractions.
  for f in fractList.split():
    result.add(newRat(f))

proc run(progStr: string; init, maxSteps: Natural = 0) =
  ## Run the program described by string "progStr" with initial value "init",
  ## stopping after "maxSteps" (0 means for ever).
  ## Display the value after each step.
  let prog = progStr.toFractions()
  var stepCount = 0
  for val in prog.values(init):
    inc stepCount
    echo stepCount, ": ", val
    if stepCount == maxSteps:
      break

iterator primes(n: Natural): int =
  # Yield the list of first "n" primes.
  let prog = PrimeProg.toFractions()
  var count = 0
  for val in prog.values(2):
    if isZero(val and (val - 1)):
      # This is a power of two.
      yield val.digits(2) - 1   # Compute the exponent as number of binary digits minus one.
      inc count
      if count == n:
        break

# Run the program to compute primes displaying values at each step and stopping after 10 steps.
echo "First ten steps for program to find primes:"
PrimeProg.run(2, 10)

# Find the first 20 primes.
echo "\nFirst twenty prime numbers:"
for val in primes(20):
  echo val
