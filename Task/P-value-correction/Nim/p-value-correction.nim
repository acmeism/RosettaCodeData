import algorithm, math, sequtils, strformat, strutils, sugar

type

  CorrectionType {.pure.} = enum
    BenjaminiHochberg = "Benjamini-Hochberg"
    BenjaminiYekutieli = "Benjamini-Yekutieli"
    Bonferroni = "Bonferroni"
    Hochberg = "Hochberg"
    Holm = "Holm"
    Hommel = "Hommel"
    Šidák = "Šidák"

  Direction {.pure.} = enum Up, Down

  PValues = seq[float]


template newPValues(length: Natural): PValues =
  ## Create a PValues object of given length.
  newSeq[float](length)


func ratchet(p: var PValues; dir: Direction) =
  var m = p[0]
  case dir
  of Up:
    for i in 1..p.high:
      if p[i] > m: p[i] = m
      m = p[i]
  of Down:
    for i in 1..p.high:
      if p[i] < m: p[i] = m
      m = p[i]
  for i in 0..p.high:
    if p[i] > 1: p[i] = 1


func schwartzian(p, mult: PValues; dir: Direction): PValues =

  let length = p.len
  let sortOrder = if dir == Up: Descending else: Ascending
  let order1 = toSeq(p.pairs).sorted((x, y) => cmp(x.val, y.val), sortOrder).mapIt(it.key)

  var pa = newPValues(length)
  for i in 0..pa.high:
    pa[i] = mult[i] * p[order1[i]]

  ratchet(pa, dir)

  let order2 = toSeq(order1.pairs).sortedByIt(it.val).mapIt(it.key)
  for idx in order2:
    result.add pa[idx]


proc adjust(p: PValues; ctype: CorrectionType): PValues =
  let length = p.len
  assert length > 0
  let flength = length.toFloat

  case ctype

  of BenjaminiHochberg:
    var mult = newPValues(length)
    for i in 0..mult.high:
      mult[i] = flength / (flength - i.toFloat)
    return schwartzian(p, mult, Up)

  of BenjaminiYekutieli:
    var q = 0.0
    for i in 1..length: q += 1 / i
    var mult = newPValues(length)
    for i in 0..mult.high:
      mult[i] = (q * flength) / (flength - i.toFloat)
    return schwartzian(p, mult, Up)

  of Bonferroni:
    result = newPValues(length)
    for i in 0..result.high:
      result[i] = min(p[i] * flength, 1)
    return

  of Hochberg:
    var mult = newPValues(length)
    for i in 0..mult.high:
      mult[i] = i.toFloat + 1
    return schwartzian(p, mult, Up)

  of Holm:
    var mult = newPValues(length)
    for i in 0..mult.high:
      mult[i] = flength - i.toFloat
    return schwartzian(p, mult, Down)

  of Hommel:
    let order1 = toSeq(p.pairs).sortedByIt(it.val).mapIt(it.key)
    let s = order1.mapIt(p[it])
    var m = Inf
    for i in 0..s.high:
      m = min(m, s[i] * flength / (i + 1).toFloat)
    var q, pa = repeat(m, length)

    for j in countdown(length - 1, 2):
      let lower = toSeq(0..length - j)
      let upper = toSeq((length - j + 1)..<length)
      var qmin = j.toFloat * s[upper[0]] / 2
      for i in 1..upper.high:
        let val = s[upper[i]] * j.toFloat / (i + 2).toFloat
        if val < qmin: qmin = val
      for idx in lower: q[idx] = min(s[idx] * j.toFloat, qmin)
      for idx in upper: q[idx] = q[^j]
      for i, val in q:
        if pa[i] < val: pa[i] = val

    let order2 = toSeq(order1.pairs).sortedByIt(it.val).mapIt(it.key)
    return order2.mapIt(pa[it])

  of Šidák:
    result = newPValues(length)
    for i in 0..result.high:
      result[i] = 1 - (1 - p[i])^length
    return


func pformat(p: PValues; cols = 5): string =
  var lines: seq[string]
  for i in countup(0, p.high, cols):
    let fchunk = p[i..<(i + cols)]
    var schunk = newSeq[string](fchunk.len)
    for j in 0..<cols:
      schunk[j] = fchunk[j].formatFloat(ffDecimal, 10)
    lines.add &"[{i:2}]  {schunk.join(\" \")}"
  result = lines.join("\n")


func adjusted(p: PValues; ctype: CorrectionType): string =
  doAssert p.len > 0 and min(p) >= 0 and max(p) <= 1, "p-values must be in range 0.0 to 1.0."
  result = &"\n{ctype}\n{pformat(p.adjust(ctype))}"

when isMainModule:

  const PVals = @[
        4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
        8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
        4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
        8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
        3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
        1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
        4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
        3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
        1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
        2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03]

  for ctype in CorrectionType:
    echo adjusted(PVals, ctype)
