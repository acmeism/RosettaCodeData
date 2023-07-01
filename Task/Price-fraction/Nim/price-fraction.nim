import random, strformat

# Representation of a standard value as an int (actual value * 100).
type StandardValue = distinct int

proc `<`(a, b: StandardValue): bool {.borrow.}

const Pricemap = [10, 18, 26, 32, 38, 44, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98, 100]


proc toStandardValue(f: float): StandardValue =
  ## Convert a float to a standard value (decimal value multiplied by 100).
  ## Index: 0.01..0.05 -> 0, 0.06..0.10 -> 1, 0.11..0.15 -> 2...
  var value = int(f * 100)
  if value == 0: return StandardValue(10)
  dec value
  # Increment index every 5 of value, so value in 1..100 translates to index in 0..19.
  let index = 2 * (value div 10) + (value mod 10) div 5
  result = StandardValue(Pricemap[index])


proc `$`(price: StandardValue): string =
  ## Return the string representation of a standard value.
  if price < StandardValue(10): "0.0" & $int(price)
  elif price < StandardValue(100): "0." & $int(price)
  else: "1.00"


when isMainModule:
  randomize()
  for _ in 0 .. 10:
    let price = rand(1.01)
    echo &"Price for {price:.2f} is {price.toStandardValue()}"
