import re, sequtils, strutils, tables
from unicode import toRunes

const

  Powers = [("0", "⁰"), ("1", "¹"), ("2", "²"), ("3", "³"), ("4", "⁴"),
            ("5", "⁵"), ("6", "⁶"), ("7", "⁷"), ("8", "⁸"), ("9", "⁹")]

  Fractions = [(".25", "¼"), (".5", "½"), (".75", "¾"), (".14285714285714", "⅐"),
               (".11111111111111", "⅑"), (".1", "⅒"), (".33333333333333", "⅓"),
               (".66666666666667", "⅔"), (".2", "⅕"), (".4", "⅖"), (".6", "⅗"),
               (".8", "⅘"), (".16666666666667", "⅙"), (".83333333333333", "⅚"),
               (".125", "⅛"), (".375", "⅜"), (".625", "⅝"), (".875", "⅞")]

  Reps1 = [(",", ""), (" ", ""), ("¼", ".25"), ("½", ".5"), ("¾", ".75"),
           ("⅐", ".14285714285714"), ("⅑", ".11111111111111"), ("⅒", ".1"),
           ("⅓", ".33333333333333"), ("⅔", ".66666666666667"), ("⅕", ".2"),
           ("⅖", ".4"), ("⅗", ".6"), ("⅘", ".8"), ("⅙", ".16666666666667"),
           ("⅚", ".83333333333333"), ("⅛", ".125"), ("⅜", ".375"), ("⅝", ".625"),
           ("⅞", ".875"), ("↉", ".0"), ("⏨", "e"), ("⁄", "/")]

  Reps2 = [("⁰", "0"), ("¹", "1"), ("²", "2"), ("³", "3"), ("⁴", "4"), ("⁵", "5"),
           ("⁶", "6"), ("⁷", "7"), ("⁸", "8"), ("⁹", "9"), ("⁻⁻", ""), ("⁻", "-"),
           ("⁺", ""), ("**", ""), ("^", ""), ("↑", ""), ("⁄", "/")]

  Eqs = [
    "-0.00x⁺¹⁰ + 1.0·x ** 5 + -2e0x^4 + +0,042.00 × x ⁺³ + +.0x² + 20.000 000 000x¹ - -1x⁺⁰ + .0x⁻¹ + 20.x¹",
    "x⁵ - 2x⁴ + 42x³ + 0x² + 40x + 1",
    "0e+0x⁰⁰⁷ + 00e-00x + 0x + .0x⁰⁵ - 0.x⁴ + 0×x³ + 0x⁻⁰ + 0/x + 0/x³ + 0x⁻⁵",
    "1x⁵ - 2x⁴ + 42x³ + 40x + 1x⁰",
    "+x⁺⁵ + -2x⁻⁻⁴ + 42x⁺⁺³ + +40x - -1",
    "x^5 - 2x**4 + 42x^3 + 40x + 1",
    "x↑5 - 2.00·x⁴ + 42.00·x³ + 40.00·x + 1",
    "x⁻⁵ - 2⁄x⁴ + 42x⁻³ + 40/x + 1x⁻⁰",
    "x⁵ - 2x⁴ + 42.000 000x³ + 40x + 1",
    "x⁵ - 2x⁴ + 0,042x³ + 40.000,000x + 1",
    "0x⁷ + 10x + 10x + x⁵ - 2x⁴ + 42x³ + 20x + 1",
    "1E0x⁵ - 2,000,000.e-6x⁴ + 4.2⏨1x³ + .40e+2x + 1",
    "x⁵ - x⁴⁄2 + 405x³⁄4 + 403x⁄4 + 5⁄2",
    "x⁵ - 0.5x⁴ + 101.25x³ + 100.75x + 2.5",
    "x⁻⁵ - 2⁄x⁴ + 42x⁻³ - 40/x",
    "⅐x⁵ - ⅓x⁴ - ⅔x⁴ + 42⅕x³ + ⅑x - 40⅛ - ⅝"]

type Coefs = Table[int, float]

proc printEquation(coefs: Coefs) =
  stdout.write "=> "
  if coefs.len == 0:
    echo "0\n"
    return

  var max = int.low
  var min = int.high
  for k in coefs.keys:
    if k > max: max = k
    if k < min: min = k

  for p in countdown(max, min):
    var c = coefs.getOrDefault(p)
    if c != 0:
      if p < max:
        var sign = '+'
        if c < 0:
          sign = '-'
          c = -c
        stdout.write ' ', sign, ' '

      if c != 1 or (c == 1 and p == 0):
        var cs = $c
        cs.trimZeros()
        let ix = cs.find('.')
        if ix >= 0:
          let d = cs[ix..^1]
          for frac in Fractions:
            if d == frac[0]:
              cs = cs.replace(d, frac[1])
              break
        if cs[0] == '0' and cs.len > 1 and cs[1] != '.':
          cs = cs[1..^1]
        stdout.write cs

      if p != 0:
        var ps = ($p).multiReplace(Powers)
        if ps == "¹": ps = ""
        stdout.write 'x', ps

  echo '\n'


template getFloat(s: string): float =
  try:
    s.parseFloat()
  except ValueError:
    quit "Expected float, got: " & s, QuitFailure

let rgx = re"\s+(\+|-)\s+"

for eq in Eqs:
  echo eq
  let terms = eq.split(rgx)
  let ops = toSeq(eq.findAll(rgx)).mapIt(it.strip())
  var coefs: Coefs
  for i, term in terms:

    let s = term.split("x")
    var t = s[0]
    t = unicode.strip(t, runes = "·× ".toRunes)
    t = t.multiReplace(Reps1)
    var c = 1.0
    var inverse = false
    if t == "" or t == "+" or t == "-": t &= '1'

    let ix = t.find('/')
    if ix == t.high:
      inverse = true
      t.setLen(t.high)
      c = t.getFloat()
    elif ix >= 0:
      let u = t.split('/')
      let m = u[0].getFloat()
      let n = u[1].getFloat()
      c = m / n
    else:
      c = t.getFloat()
    if i > 0 and ops[i - 1] == "-": c = -c
    if c == -0.0: c = 0.0

    if s.len == 1:
      coefs[0] = coefs.getOrDefault(0) + c
      continue

    var u = s[1].strip()
    if u.len == 0:
      let p = if inverse: -1 else: 1
      if c != 0:
        coefs[p] = coefs.getOrDefault(p) + c
      continue

    u = u.multiReplace(Reps2)
    let jx = u.find('/')
    var p: int
    if jx >= 0:
      let v = u.split('/')
      p = try: v[0].parseInt() except ValueError: 1
      let d = v[1].getFloat()
      c /= d
    else:
      p = try: u.strip().parseInt() except ValueError: 1
    if inverse: p = -p
    if c != 0: coefs[p] = coefs.getOrDefault(p) + c

  printEquation(coefs)
