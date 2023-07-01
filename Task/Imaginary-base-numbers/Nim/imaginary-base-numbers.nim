import algorithm, complex, math, strformat, strutils

const
  TwoI = complex(0.0, 2.0)
  InvTwoI = inv(TwoI)

type QuaterImaginery = object
  b2i: string

# Conversions between digit character and digit value.
template digitChar(n: range[0..9]): range['0'..'9'] = chr(n + ord('0'))
template digitValue(c: range['0'..'9']): range[0..9] = ord(c) - ord('0')


####################################################################################################
# Quater imaginary functions.

func initQuaterImaginary(s: string): QuaterImaginery =
  ## Create a Quater imaginary number.
  if s.len == 0 or not s.allCharsInSet({'0'..'3', '.'}) or s.count('.') > 1:
    raise newException(ValueError, "invalid base 2i number.")
  result = QuaterImaginery(b2i: s)

#---------------------------------------------------------------------------------------------------

func toComplex(q: QuaterImaginery): Complex[float] =
  ## Convert a Quater imaginary number to a complex.

  let pointPos = q.b2i.find('.')
  let posLen = if pointPos != -1: pointPos else: q.b2i.len
  var prod = complex(1.0)

  for j in 0..<posLen:
    let k = float(q.b2i[posLen - 1 - j].digitValue)
    if k > 0: result += prod * k
    prod *= TwoI

  if pointPos != -1:
    prod = InvTwoI
    for j in (posLen + 1)..q.b2i.high:
      let k = float(q.b2i[j].digitValue)
      if k > 0: result += prod * k
      prod *= InvTwoI

#---------------------------------------------------------------------------------------------------

func `$`(q: QuaterImaginery): string =
  ## Convert a Quater imaginary number to a string.
  q.b2i


####################################################################################################
# Supplementary functions for complex numbers.

func toQuaterImaginary(c: Complex): QuaterImaginery =
  ## Convert a complex number to a Quater imaginary number.

  if c.re == 0 and c.im == 0: return initQuaterImaginary("0")

  var re = c.re.toInt
  var im = c.im.toInt
  var fi = -1

  while re != 0:
    var rem = re mod -4
    re = re div -4
    if rem < 0:
      inc rem, 4
      inc re
    result.b2i.add rem.digitChar
    result.b2i.add '0'

  if im != 0:
    var f = (complex(0.0, c.im) / TwoI).re
    im = f.ceil.toInt
    f = -4 * (f - im.toFloat)
    var index = 1
    while im != 0:
      var rem = im mod -4
      im = im div -4
      if rem < 0:
        inc rem, 4
        inc im
      if index < result.b2i.len:
        result.b2i[index] = rem.digitChar
      else:
        result.b2i.add '0'
        result.b2i.add rem.digitChar
      inc index, 2
    fi = f.toInt

  result.b2i.reverse()
  if fi != -1: result.b2i.add "." & $fi
  result.b2i = result.b2i.strip(leading = true, trailing = false, {'0'})
  if result.b2i.startsWith('.'): result.b2i = '0' & result.b2i

#---------------------------------------------------------------------------------------------------

func toString(c: Complex[float]): string =
  ## Convert a complex number to a string.
  ## This function is used in place of `$`.

  let real = if c.re.classify == fcNegZero: 0.0 else: c.re
  let imag = if c.im.classify == fcNegZero: 0.0 else: c.im
  result = if imag >= 0: fmt"{real} + {imag}i" else: fmt"{real} - {-imag}i"
  result = result.replace(".0 ", " ").replace(".0i", "i").replace(" + 0i", "")
  if result.startsWith("0 + "): result = result[4..^1]
  if result.startsWith("0 - "): result = '-' & result[4..^1]


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  for i in 1..16:
    var c1 = complex(i.toFloat)
    var qi = c1.toQuaterImaginary
    var c2 = qi.toComplex
    stdout.write fmt"{c1.toString:>4s} → {qi:>8s} → {c2.toString:>4s}     "
    c1 = -c1
    qi = c1.toQuaterImaginary
    c2 = qi.toComplex
    echo fmt"{c1.toString:>4s} → {qi:>8s} → {c2.toString:>4s}"

  echo ""

  for i in 1..16:
    var c1 = complex(0.0, i.toFloat)
    var qi = c1.toQuaterImaginary
    var c2 = qi.toComplex
    stdout.write fmt"{c1.toString:>4s} → {qi:>8s} → {c2.toString:>4s}     "
    c1 = -c1
    qi = c1.toQuaterImaginary
    c2 = qi.toComplex
    echo fmt"{c1.toString:>4s} → {qi:>8s} → {c2.toString:>4s}"
