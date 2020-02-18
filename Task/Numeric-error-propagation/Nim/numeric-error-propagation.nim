import strformat
import math

type
  Imprecise = object
    x: float
    σ: float

template `^`(a, b: float): float =
  pow(a, b)
template `-`(a: Imprecise): Imprecise =
  Imprecise(x: -a.x, σ: a.σ)
template `+`(a, b: Imprecise): Imprecise =
  Imprecise(x: a.x + b.x, σ: sqrt(a.σ ^ 2 + b.σ ^ 2))
template `-`(a, b: Imprecise): Imprecise =
  Imprecise(x: a.x - b.x, σ: sqrt(a.σ ^ 2 + b.σ ^ 2))
template `*`(a, b: Imprecise): Imprecise =
  let x = a.x * b.x
  let σ = sqrt(x ^ 2 * ((a.σ / a.x) ^ 2 + (b.σ / b.x) ^ 2))
  Imprecise(x: x, σ: σ)
template `/`(a, b: Imprecise): Imprecise =
  let x = a.x / b.x
  let σ = sqrt(x ^ 2 * ((a.σ / a.x) ^ 2 + (b.σ / b.x) ^ 2))
  Imprecise(x: x, σ: σ)
template `^`(a: Imprecise, b: float): Imprecise =
  if b < 0:
    raise newException(IOError, "Cannot raise to negative power.")
  let x = a.x ^ b
  let σ = abs(x * b * a.σ / a.x)
  Imprecise(x: x, σ: σ)
template sqrt(a: Imprecise): Imprecise =
  a ^ 0.5

proc `$`(a: Imprecise): string =
  fmt"{a.x:.2f} ± {a.σ:.2f}"

var x1 = Imprecise(x: 100, σ: 1.1)
var y1 = Imprecise(x: 50, σ: 1.2)
var x2 = Imprecise(x: 200, σ: 2.2)
var y2 = Imprecise(x: 100, σ: 2.3)

echo $(sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2))
