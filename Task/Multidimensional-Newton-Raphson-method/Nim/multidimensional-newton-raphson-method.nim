import sequtils, strformat, sugar

type
  Vector = seq[float]
  Matrix = seq[Vector]
  Func = (Vector) -> float
  Funcs = seq[Func]
  Jacobian = seq[Funcs]


func `*`(m1, m2: Matrix): Matrix =
  let
    rows1 = m1.len
    cols1 = m1[0].len
    rows2 = m2.len
    cols2 = m2[0].len
  doAssert cols1 == rows2
  result = newSeqWith(rows1, newSeq[float](cols2))
  for i in 0..<rows1:
    for j in 0..<cols2:
      for k in 0..<rows2:
        result[i][j] += m1[i][k] * m2[k][j]


func `-`(m1, m2: Matrix): Matrix =
  let
    rows = m1.len
    cols = m1[0].len
  doAssert m2.len == rows and m2[0].len == cols
  result = newSeqWith(rows, newSeq[float](cols))
  for i in 0..<rows:
    for j in 0..<cols:
      result[i][j] = m1[i][j] - m2[i][j]


func transposed(m: Matrix): Matrix =
  let
    rows = m.len
    cols = m[0].len
  result = newSeqWith(cols, newSeq[float](rows))
  for i in 0..<cols:
    for j in 0..<rows:
      result[i][j] = m[j][i]


func toReducedRowEchelonForm(m: var Matrix) =
  var lead = 0
  let rowCount = m.len
  let colCount = m[0].len
  for r in 0..<rowCount:
    if colCount <= lead: return
    var i = r

    while m[i][lead] == 0:
      inc i
      if rowCount == i:
        i = r
        inc lead
        if colCount == lead: return

    swap m[i], m[r]

    if m[r][lead] != 0:
      let divisor = m[r][lead]
      for j in 0..<colCount: m[r][j] /= divisor

    for k in 0..<rowCount:
      if k != r:
        let mult = m[k][lead]
        for j in 0..<colCount: m[k][j] -= m[r][j] * mult

    inc lead


func inverse(m: Matrix): Matrix =
  let size = m.len
  doAssert m.allIt(it.len == size), "not a square matrix."
  var aug = newSeqWith(size, newSeq[float](2 * size))
  for i in 0..<size:
    for j in 0..<size: aug[i][j] = m[i][j]
    # Augment by identity matrix to right.
    aug[i][i + size] = 1
  aug.toReducedRowEchelonForm()
  result = newSeqWith(size, newSeq[float](size))
  # Remove identity matrix to left.
  for i in 0..<size:
    for j in 0..<size: result[i][j] = aug[i][j + size]


proc solve(funcs: Funcs; jacobian: Jacobian; guesses: Vector): Vector =
  let size = funcs.len
  result = guesses
  var jac = newSeqWith(size, newSeq[float](size))
  const Tol = 1e-8
  let MaxIter = 12
  var iter = 1
  while true:
    let gu = move(result)
    let g = transposed(@[gu])
    let f = transposed(@[funcs.mapIt(it(gu))])
    for i in 0..<size:
      for j in 0..<size:
        jac[i][j] = jacobian[i][j](gu)
    let g1 = g - inverse(jac) * f
    result = g1.mapIt(it[0])
    inc iter
    if iter > MaxIter: break
    var exit = true
    for idx, val in result:
      if abs(val - gu[idx]) > Tol:
        exit = false
        break
    if exit: break


when isMainModule:

  #[ Solve the two non-linear equations:
     y = -x^2 + x + 0.5
     y + 5xy = x^2
     given initial guesses of x = y = 1.2

     Example taken from:
     http://www.fixoncloud.com/Home/LoginValidate/OneProblemComplete_Detailed.php?problemid=286

     Expected results: x = 1.23332, y = 0.2122
  ]#

  let
    f1: Func = (x: Vector) => -x[0] * x[0] + x[0] + 0.5 - x[1]
    f2: Func = (x: Vector) => x[1] + 5 * x[0] * x[1] - x[0] * x[0]
    funcs1: Funcs = @[f1, f2]
    jacobian1: Jacobian = @[@[Func((x: Vector) => - 2 * x[0] + 1),
                              Func((x: Vector) => -1.0)],
                            @[Func((x: Vector) => 5 * x[1] - 2 * x[0]),
                              Func((x: Vector) => 1 + 5 * x[0])]]

    guesses1 = @[1.2, 1.2]
    sol1 = solve(funcs1, jacobian1, guesses1)
  echo &"Approximate solutions are x = {sol1[0]:.7f},  y = {sol1[1]:.7f}"

  #[ Solve the three non-linear equations:
     9x^2 + 36y^2 + 4z^2 - 36 = 0
     x^2 - 2y^2 - 20z = 0
     x^2 - y^2 + z^2 = 0
     given initial guesses of x = y = 1.0 and z = 0.0

     Example taken from:
     http://mathfaculty.fullerton.edu/mathews/n2003/FixPointNewtonMod.html (exercise 5)

     Expected results: x = 0.893628, y = 0.894527, z = -0.0400893
  ]#

  echo()
  let
    f3: Func = (x: Vector) => 9 * x[0] * x[0] + 36 * x[1] * x[1] + 4 * x[2] * x[2] - 36
    f4: Func = (x: Vector) => x[0] * x[0] - 2 * x[1] * x[1] - 20 * x[2]
    f5: Func = (x: Vector) => x[0] * x[0] - x[1] * x[1] + x[2] * x[2]
    funcs2: Funcs = @[f3, f4, f5]
    jacobian2: Jacobian = @[@[Func((x: Vector) => 18 * x[0]),
                              Func((x: Vector) => 72 * x[1]),
                              Func((x: Vector) =>  8 * x[2])],
                            @[Func((x: Vector) =>  2 * x[0]),
                              Func((x: Vector) => -4 * x[1]),
                              Func((x: Vector) => -20.0)],
                            @[Func((x: Vector) =>  2 * x[0]),
                              Func((x: Vector) => -2 * x[1]),
                              Func((x: Vector) =>  2 * x[2])]]
    guesses2 = @[1.0, 1.0, 0.0]
    sol2 = solve(funcs2, jacobian2, guesses2)
  echo &"Approximate solutions are x = {sol2[0]:.7f},  y = {sol2[1]:.7f}, z = {sol2[2]:.7f}"
