import strformat

type MaxTropical = distinct float

const MinusInfinity = MaxTropical NegInf

# Borrowed functions.
func `<=`(a, b: MaxTropical): bool {.borrow.}   # required by "max".
func `==`(a, b: MaxTropical): bool {.borrow}
func `$`(a: MaxTropical): string {.borrow.}

# ⊕ operator.
func `+`(a, b: MaxTropical): MaxTropical = max(a, b)

# ⊗ operator.
func `*`(a, b: MaxTropical): MaxTropical = MaxTropical float(a) + float(b)

# ⊗= operator, used here for exponentiation.
func `*=`(a: var MaxTropical; b: MaxTropical) =
  float(a) += float(b)

# ↑ operator (this can be seen as an overloading of the ^ operator from math module).
func `^`(a: MaxTropical; b: Positive): MaxTropical =
  case b
  of 1: return a
  of 2: return a * a
  of 3: return a * a * a
  else:
    result = a
    for n in 2..b:
      result *= a


echo &"2 ⊗ -2 = {MaxTropical(2) * MaxTropical(-2)}"
echo &"-0.001 ⊕ -Inf = {MaxTropical(-0.001) + MinusInfinity}"
echo &"0 ⊗ -Inf = {MaxTropical(0) * MinusInfinity}"
echo &"1.5 ⊕ -1 = {MaxTropical(1.5) + MaxTropical(-1)}"
echo &"-0.5 ⊗ 0 = {MaxTropical(-0.5) * MaxTropical(0)}"
echo &"5↑7 = {MaxTropical(5)^7}"
echo()
let x = MaxTropical(5) * (MaxTropical(8) + MaxTropical(7))
let y = MaxTropical(5) * MaxTropical(8) + MaxTropical(5) * MaxTropical(7)
echo &"5 ⊗ (8 ⊕ 7) = {x}"
echo &"5 ⊗ 8 ⊕ 5 ⊗ 7 = {y}"
echo &"So 5 ⊗ (8 ⊕ 7) equals 5 ⊗ 8 ⊕ 5 ⊗ 7 is {x == y}."
