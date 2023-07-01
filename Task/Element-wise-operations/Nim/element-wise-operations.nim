import math, strutils

type Matrix[height, width: static Positive; T: SomeNumber] = array[height, array[width, T]]

####################################################################################################

proc `$`(m: Matrix): string =
  for i, row in m:
    var line = "["
    for j, val in row:
      line.addSep(" ", 1)
      line.add($val)
    line.add("]\n")
    result.add(line)

####################################################################################################
# Templates.

template elementWise(m1, m2: Matrix; op: proc(v1, v2: m1.T): auto): untyped =
  var result: Matrix[m1.height, m1.width, m1.T]
  for i in 0..<m1.height:
    for j in 0..<m1.width:
      result[i][j] = op(m1[i][j], m2[i][j])
  result

template scalarOp(m: Matrix; val: SomeNumber; op: proc(v1, v2: SomeNumber): auto): untyped =
  var result: Matrix[m.height, m.width, m.T]
  for i in 0..<m.height:
    for j in 0..<m.width:
      result[i][j] = op(m[i][j], val)
  result

template scalarOp(val: SomeNumber; m: Matrix; op: proc(v1, v2: SomeNumber): auto): untyped =
  var result: Matrix[m.height, m.width, m.T]
  for i in 0..<m.height:
    for j in 0..<m.width:
      result[i][j] = op(val, m[i][j])
  result

####################################################################################################
# Access functions.

func `[]`(m: Matrix; i, j: int): m.T =
  m[i][j]

func `[]=`(m: var Matrix; i, j: int; val: SomeNumber) =
  m[i][j] = val

####################################################################################################
# Elementwise operations.

func `+`(m1, m2: Matrix): Matrix =
  elementWise(m1, m2, `+`)

func `-`(m1, m2: Matrix): Matrix =
  elementWise(m1, m2, `-`)

func `*`(m1, m2: Matrix): Matrix =
  elementWise(m1, m2, `*`)

func `div`(m1, m2: Matrix): Matrix =
  elementWise(m1, m2, `div`)

func `mod`(m1, m2: Matrix): Matrix =
  elementWise(m1, m2, `mod`)

func `/`(m1, m2: Matrix): Matrix =
  elementWise(m1, m2, `/`)

func `^`(m1, m2: Matrix): Matrix =
  # Cannot use "elementWise" template as it requires both operator arguments
  # to be of type "m1.T" (and second argument of `^` is "Natural", not "int").
  for i in 0..<m1.height:
    for j in 0..<m1.width:
      result[i][j] = m1[i][j] ^ m2[i][j]

func pow(m1, m2: Matrix): Matrix =
  elementWise(m1, m2, pow)

####################################################################################################
# Matrix-scalar and scalar-matrix operations.

func `+`(m: Matrix; val: SomeNumber): Matrix =
  scalarOp(m, val, `+`)

func `+`(val: SomeNumber; m: Matrix): Matrix =
  scalarOp(val, m, `+`)

func `-`(m: Matrix; val: SomeNumber): Matrix =
  scalarOp(m, val, `-`)

func `-`(val: SomeNumber; m: Matrix): Matrix =
  scalarOp(val, m, `-`)

func `*`(m: Matrix; val: SomeNumber): Matrix =
  scalarOp(m, val, `*`)

func `*`(val: SomeNumber; m: Matrix): Matrix =
  scalarOp(val, m, `*`)

func `div`(m: Matrix; val: SomeNumber): Matrix =
  scalarOp(m, val, `div`)

func `div`(val: SomeNumber; m: Matrix): Matrix =
  scalarOp(val, m, `div`)

func `mod`(m: Matrix; val: m.T): Matrix =
  scalarOp(m, val, `mod`)

func `mod`(val: SomeNumber; m: Matrix): Matrix =
  scalarOp(val, m, `mod`)

proc `/`(m: Matrix; val: SomeNumber): Matrix =
  scalarOp(m, val, `/`)

func `/`(val: SomeNumber; m: Matrix): Matrix =
  scalarOp(val, m, `/`)

func `^`(m: Matrix; val: Natural): Matrix =
  # Cannot use "elementWise" template as it requires both operator arguments
  # to be of type "m.T" (and second argument of `^` is "Natural", not "int").
  for i in 0..<m.height:
    for j in 0..<m.width:
      result[i][j] = m[i][j] ^ val

func `^`(val: Natural; m: Matrix): Matrix =
  # Cannot use "elementWise" template as it requires both operator arguments
  # to be of type "m.T" (and second argument of `^` is "Natural", not "int").
  for i in 0..<m.height:
    for j in 0..<m.width:
      result[i][j] = val ^ m[i][j]

func pow(m: Matrix; val: SomeNumber): Matrix =
  scalarOp(m, val, pow)

func `pow`(val: SomeNumber; m: Matrix): Matrix =
  scalarOp(val, m, `pow`)

#———————————————————————————————————————————————————————————————————————————————————————————————————

# Operations on integer matrices.
let mint1: Matrix[2, 2, int] = [[1, 2], [3, 4]]
let mint2: Matrix[2, 2, int] = [[2, 1], [4, 2]]
echo "Integer matrices"
echo "----------------\n"
echo "m1:"
echo mint1
echo "m2:"
echo mint2
echo "m1 + m2"
echo mint1 + mint2
echo "m1 - m2"
echo mint1 - mint2
echo "m1 * m2"
echo mint1 * mint2
echo "m1 div m2"
echo mint1 div mint2
echo "m1 mod m2"
echo mint1 mod mint2
echo "m1^m2"
echo mint1^mint2
echo "2 * m1"
echo 2 * mint1
echo "m1 * 2"
echo mint1 * 2
echo "m1^2"
echo mint1 ^ 2
echo "2^m1"
echo 2 ^ mint1

# Operations on float matrices.
let mfloat1: Matrix[2, 3, float] = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
let mfloat2: Matrix[2, 3, float] = [[2.0, 2.0, 2.0], [3.0, 3.0, 3.0]]
echo "\nFloat matrices"
echo "--------------\n"
echo "m1"
echo mfloat1
echo "m2"
echo mfloat2
echo "m1 + m2"
echo mfloat1 + mfloat2
echo "m1 - m2"
echo mfloat1 - mfloat2
echo "m1 * m2"
echo mfloat1 * mfloat2
echo "m1 / m2"
echo mfloat1 / mfloat2
echo "pow(m1, m2)"
echo pow(mfloat1, mfloat2)
echo "pow(m1, 2.0)"
echo pow(mfloat1, 2.0)
echo "pow(2.0, m1)"
echo pow(2.0, mfloat1)
