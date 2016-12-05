import complex, math

proc rect(r, phi: float): Complex = (r * cos(phi), sin(phi))

proc croots(n): seq[Complex] =
  result = @[]
  if n <= 0: return
  for k in 0 .. < n:
    result.add rect(1, 2 * k.float * Pi / n.float)

for nr in 2..10:
  echo nr, " ", croots(nr)
