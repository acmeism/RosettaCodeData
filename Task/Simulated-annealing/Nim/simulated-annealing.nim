import math, random, sequtils, strformat

const
  kT = 1
  kMax = 1_000_000

proc randomNeighbor(x: int): int =
  case x
  of 0:
    sample([1, 10, 11])
  of 9:
    sample([8, 18, 19])
  of 90:
    sample([80, 81, 91])
  of 99:
    sample([88, 89, 98])
  elif x > 0 and x < 9:   # top ceiling
    sample [x-1, x+1, x+9, x+10, x+11]
  elif x > 90 and x < 99: # bottom floor
    sample [x-11, x-10, x-9, x-1, x+1]
  elif x mod 10 == 0:     # left wall
    sample([x-10, x-9, x+1, x+10, x+11])
  elif (x+1) mod 10 == 0: # right wall
    sample([x-11, x-10, x-1, x+9, x+10])
  else: # center
    sample([x-11, x-10, x-9, x-1, x+1, x+9, x+10, x+11])

proc neighbor(s: seq[int]): seq[int] =
  result = s
  var city = sample(s)
  var cityNeighbor = city.randomNeighbor
  while cityNeighbor == 0 or city == 0:
    city = sample(s)
    cityNeighbor = city.randomNeighbor
  result[s.find city].swap result[s.find cityNeighbor]

func distNeighbor(a, b: int): float =
  template divmod(a: int): (int, int) = (a div 10, a mod 10)
  let
    (diva, moda) = a.divmod
    (divb, modb) = b.divmod
  hypot((diva-divb).float, (moda-modb).float)

func temperature(k, kmax: float): float =
  kT * (1 - (k / kmax))

func pdelta(eDelta, temp: float): float =
  if eDelta < 0: 1.0
  else: exp(-eDelta / temp)

func energy(path: seq[int]): float =
  var sum = 0.distNeighbor path[0]
  for i in 1 ..< path.len:
    sum += path[i-1].distNeighbor(path[i])
  sum + path[^1].distNeighbor 0

proc main =
  randomize()
  var
    s = block:
      var x = toSeq(0..99)
      template shuffler: int = rand(1 .. x.high)
      for i in 1 .. x.high:
        x[i].swap x[shuffler()]
      x
  echo fmt"E(s0): {energy s:6.4f}"
  for k in 0 .. kMax:
    var
      temp = temperature(float k, float kMax)
      lastenergy = energy s
      newneighbor = s.neighbor
      newenergy = newneighbor.energy
    if k mod (kMax div 10) == 0:
      echo fmt"k: {k:7} T: {temp:6.2f} Es: {lastenergy:6.4f}"
    var deltaEnergy = newenergy - lastenergy
    if pDelta(deltaEnergy, temp) >= rand(1.0):
      s = newneighbor

  s.add 0
  echo fmt"E(sFinal): {energy s:6.4f}"
  echo fmt"path: {s}"

main()
