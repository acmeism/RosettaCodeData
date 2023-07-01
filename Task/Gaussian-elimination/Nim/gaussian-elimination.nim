const Eps = 1e-14   # Tolerance required.

type

  Vector[N: static Positive] = array[N, float]
  Matrix[M, N: static Positive] = array[M, Vector[N]]
  SquareMatrix[N: static Positive] = Matrix[N, N]

func gaussPartialScaled(a: SquareMatrix; b: Vector): Vector =

  doAssert a.N == b.N, "matrix and vector have incompatible dimensions"
  const N = a.N

  var m: Matrix[N, N + 1]
  for i, row in a:
    m[i][0..<N] = row
    m[i][N] = b[i]

  for k in 0..<N:
    var imax = 0
    var vmax = -1.0

    for i in k..<N:
      # Compute scale factor s = max abs in row.
      var s = -1.0
      for j in k..N:
        let e = abs(m[i][j])
        if e > s: s = e
      # Scale the abs used to pick the pivot.
      let val = abs(m[i][k]) / s
      if val > vmax:
        imax = i
        vmax = val

    if m[imax][k] == 0:
      raise newException(ValueError, "matrix is singular")

    swap m[imax], m[k]

    for i in (k + 1)..<N:
      for j in (k + 1)..N:
        m[i][j] -= m[k][j] * m[i][k] / m[k][k]
      m[i][k] = 0

  for i in countdown(N - 1, 0):
    result[i] = m[i][N]
    for j in (i + 1)..<N:
      result[i] -= m[i][j] * result[j]
    result[i] /= m[i][i]


#———————————————————————————————————————————————————————————————————————————————————————————————————

let a: SquareMatrix[6] = [[1.00, 0.00, 0.00,  0.00,  0.00,   0.00],
                          [1.00, 0.63, 0.39,  0.25,  0.16,   0.10],
                          [1.00, 1.26, 1.58,  1.98,  2.49,   3.13],
                          [1.00, 1.88, 3.55,  6.70, 12.62,  23.80],
                          [1.00, 2.51, 6.32, 15.88, 39.90, 100.28],
                          [1.00, 3.14, 9.87, 31.01, 97.41, 306.02]]

let b: Vector[6] = [-0.01, 0.61, 0.91, 0.99, 0.60, 0.02]

let refx: Vector[6] = [-0.01, 1.602790394502114, -1.6132030599055613,
                       1.2454941213714368, -0.4909897195846576, 0.065760696175232]

let x = gaussPartialScaled(a, b)
echo x
for i, xi in x:
  if abs(xi - refx[i]) > Eps:
    echo "Out of tolerance."
    echo "Expected values are ", refx
    break
