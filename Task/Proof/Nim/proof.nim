import strformat, sugar

type

  # Natural number.
  Number = ref object
    pred: Number

  # Even natural number: 2 × half.
  EvenNumber = ref object
    half: Number

  # Odd natural number: 2 × half + 1.
  OddNumber = ref object
    half: Number

const Zero: Number = nil

# Contructors.
func newNumber(pred: Number): auto = Number(pred: pred)
func newEvenNumber(half: Number): auto = EvenNumber(half: half)
func newOddNumber(half: Number): auto = OddNumber(half: half)

func isZero(n: Number): bool =
  ## Test whether a natural number is zero.
  n.isNil

func inc(n: Number): Number =
  ## Increment a natural number.
  newNumber(n)

func dec(n: Number): Number =
  ## Decrement a natural number.
  n.pred

func `+`(x, y: Number): Number =
  ## Add two natural numbers.
  if y.isZero: x else: x.inc + y.dec

func `+`(x, y: EvenNumber): EvenNumber =
  ## Add two even natural numbers.
  if y.half.isZero: x else: newEvenNumber(x.half + y.half)

func `+`(x, y: OddNumber): EvenNumber =
  ## Add two odd natural numbers.
  newEvenNumber(inc(x.half + y.half))

func newNumber(n: Natural): Number =
  ## Build a natural number from a Nim Natural.
  if n > 0: inc(newNumber(n - 1)) else: Zero

func count(n: Number): Natural =
  ## Return the integer representation of a natural number.
  if n.isZero: 0 else: count(dec(n)) + 1

func count(n: EvenNumber): Natural =
  ## Return the integer representation of an even natural number.
  n.half.count * 2

func count(n: OddNumber): Natural =
  ## Return the integer representation of an odd natural number.
  n.half.count * 2 + 1

proc testCommutative(e1, e2: EvenNumber) =
  ## Test if even number addition is commutative for given numbers.
  let c1 = e1.count
  let c2 = e2.count
  let passed = count(e1 + e2) == count(e2 + e1)
  let symbol = if passed: "==" else: "!="
  echo &"\n{c1} + {c2} {symbol} {c2} + {c1}"

proc testAssociative(e1, e2, e3: EvenNumber) =
  ## Test if even number arithmetic is associative.
  let c1 = e1.count
  let c2 = e2.count
  let c3 = e3.count
  let passed = count((e1 + e2) + e3) == count(e1 + (e2 + e3))
  let symbol = if passed: "==" else: "!="
  echo &"\n({c1} + {c2}) + {c3} {symbol} {c1} + ({c2} + {c3})"


let numbers = collect(newSeq, for i in 0..9: newNumber(i))

echo "The first 10 even natural numbers are:"
for i, n in numbers:
  stdout.write n.count, if i == 9: '\n' else: ' '

echo "\nThe first 10 even natural numbers are:"
for i, n in numbers:
  stdout.write newEvenNumber(n).count, if i == 9: '\n' else: ' '

echo "\nThe first 10 odd natural numbers are:"
for i, n in numbers:
  stdout.write newOddNumber(n).count, if i == 9: '\n' else: ' '

var sum = Zero
for n in numbers: sum = sum + n
echo &"\nThe sum of the first 10 natural numbers is: {sum.count}"

var evenSum = newEvenNumber(Zero)
for n in numbers: evenSum = evenSum + newEvenNumber(n)
echo &"\nThe sum of the first 10 even natural numbers (increasing order) is: {evenSum.count}"

evenSum = newEvenNumber(Zero)
for i in countdown(9, 0): evenSum = evenSum + newEvenNumber(numbers[i])
echo &"\nThe sum of the first 10 even natural numbers (decreasing order) is: {evenSum.count}"

testCommutative(newEvenNumber(numbers[8]), newEvenNumber(numbers[9]))

testAssociative(newEvenNumber(numbers[7]), newEvenNumber(numbers[8]), newEvenNumber(numbers[9]))
