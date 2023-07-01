import strutils
import bignum

type Currency = Int

#---------------------------------------------------------------------------------------------------

func currency(units, subunits: int): Currency =
  ## Build a currency from units and subunits.
  ## Units may be negative. Subunits must be in range 0..99.
  if subunits notin 0..99:
    raise newException(ValueError, "wrong value for subunits")
  result = if units >= 0: newInt(units * 100 + subunits)
           else: newInt(subunits * 100 - subunits)

#---------------------------------------------------------------------------------------------------

func currency(value: string): Currency =
  ## Build a currency from a string.
  ## Negative values are allowed. At most two digits are allowed for subunits.

  const StartingChars = Digits + {'-'}
  if value.len == 0 or value[0] notin StartingChars:
    raise newException(ValueError, "wrong currency string")

  # process sign and units.
  var units = newInt(0)
  var subunits = 0
  let sign = if value[0] == '-': -1 else: 1
  var idx = if sign == 1: 0 else: 1
  while idx < value.len:
    if value[idx] notin Digits: break
    units = 10 * units + ord(value[idx]) - ord('0')
    inc idx

  # Process separator.
  if idx <= value.high:
    if value[idx] != '.':
      raise newException(ValueError, "expected a separator")
    inc idx

  # Process subunits.
  for _ in 0..1:
    let c = if idx >= value.len: '0' else: value[idx]
    if c notin Digits:
      raise newException(ValueError, "wrong value for subunits")
    subunits = 10 * subunits + ord(c) - ord('0')
    inc idx

  if idx <= value.high:
    raise newException(ValueError, "extra characters after subunits digits")

  result = sign * (units * 100 + subunits)

#---------------------------------------------------------------------------------------------------

func `//`(a, b: int): Rat =
  ## Create a rational value.
  newRat(a, b)

#---------------------------------------------------------------------------------------------------

func percentage(a: Currency; p: Rat): Currency =
  ## Compute a percentage on currency value "a".
  ## Returned value is rounded to nearest integer.

  (a * p.num * 10 div p.denom + 5) div 10

#---------------------------------------------------------------------------------------------------

func `$`(a: Currency): string =
  ## Build a string representation of a currency value.

  result = bignum.`$`(a div 100) & '.' & ($(a mod 100).toInt).align(2, '0')

#———————————————————————————————————————————————————————————————————————————————————————————————————

let hamburgers = currency(5, 50) * int 4_000_000_000_000_000
let milkshakes = currency("2.86") * 2
let rate = 765 // 10_000
let beforeTax = hamburgers + milkshakes
let tax = beforeTax.percentage(rate)
let total = beforeTax + tax

# Find the maximum length of numerical value representations.
let beforeTaxStr = $beforeTax
let taxStr = $tax
let totalStr = $total
let length = max([beforeTaxStr.len, taxStr.len, totalStr.len])

# Display the results.
echo "Total price before tax: ", beforeTaxStr.align(length)
echo "Tax:                    ", taxStr.align(length)
echo "Total with tax:         ", totalStr.align(length)
