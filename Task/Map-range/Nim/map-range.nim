import strformat

type FloatRange = tuple[s, e: float]

proc mapRange(a, b: FloatRange; s: float): float =
  b.s + (s - a.s) * (b.e - b.s) / (a.e - a.s)

for i in 0..10:
  let m = mapRange((0.0,10.0), (-1.0, 0.0), float(i))
  echo &"{i:>2} maps to {m:4.1f}"
