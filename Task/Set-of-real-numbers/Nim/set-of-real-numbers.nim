import math, strformat, sugar

type

  RealPredicate = (float) -> bool

  RangeType {.pure} = enum Closed, BothOpen, LeftOpen, RightOpen

  RealSet = object
    low, high: float
    predicate: RealPredicate


proc initRealSet(slice: Slice[float]; rangeType: RangeType): RealSet =
  result = RealSet(low: slice.a, high: slice.b)
  result.predicate = case rangeType
                     of Closed: (x: float) => x in slice
                     of BothOpen: (x: float) => slice.a < x and x < slice.b
                     of LeftOpen: (x: float) => slice.a < x and x <= slice.b
                     of RightOpen: (x: float) => slice.a <= x and x < slice.b


proc contains(s: RealSet; val: float): bool =
  ## Defining "contains" makes operator "in" available.
  s.predicate(val)


proc `+`(s1, s2: RealSet): RealSet =
  RealSet(low: min(s1.low, s2.low), high: max(s1.high, s2.high),
          predicate: (x:float) => s1.predicate(x) or s2.predicate(x))


proc `*`(s1, s2: RealSet): RealSet =
  RealSet(low: max(s1.low, s2.low), high: min(s1.high, s2.high),
          predicate: (x:float) => s1.predicate(x) and s2.predicate(x))


proc `-`(s1, s2: RealSet): RealSet =
  RealSet(low: s1.low, high: s1.high,
          predicate: (x:float) => s1.predicate(x) and not s2.predicate(x))


const Interval = 0.00001

proc length(s: RealSet): float =
  if s.low.classify() in {fcInf, fcNegInf} or s.high.classify() in {fcInf, fcNegInf}: return Inf
  if s.high <= s.low: return 0
  var p = s.low
  var count = 0.0
  while p < s.high:
    if s.predicate(p): count += 1
    p += Interval
  result = count * Interval


proc isEmpty(s: RealSet): bool =
  if s.high == s.low: not s.predicate(s.low)
  else: s.length == 0


when isMainModule:
  let
    a = initRealSet(0.0..1.0, LeftOpen)
    b = initRealSet(0.0..2.0, RightOpen)
    c = initRealSet(1.0..2.0, LeftOpen)
    d = initRealSet(0.0..3.0, RightOpen)
    e = initRealSet(0.0..1.0, BothOpen)
    f = initRealSet(0.0..1.0, Closed)
    g = initRealSet(0.0..0.0, Closed)

  for n in 0..2:
    let x = n.toFloat
    echo &"{n} ∊ (0, 1] ∪ [0, 2) is {x in (a + b)}"
    echo &"{n} ∊ [0, 2) ∩ (1, 2] is {x in (b * c)}"
    echo &"{n} ∊ [0, 3) − (0, 1) is {x in (d - e)}"
    echo &"{n} ∊ [0, 3) − [0, 1] is {x in (d - f)}\n"

  echo &"[0, 0] is empty is {g.isEmpty()}.\n"

  let
    aa = RealSet(low: 0, high: 10,
                 predicate: (x: float) => 0 < x and x < 10 and abs(sin(PI * x * x)) > 0.5)
    bb = RealSet(low: 0, high: 10,
                 predicate: (x: float) => 0 < x and x < 10 and abs(sin(PI * x)) > 0.5)
    cc = aa - bb

  echo &"Approximative length of A - B is {cc.length}."
