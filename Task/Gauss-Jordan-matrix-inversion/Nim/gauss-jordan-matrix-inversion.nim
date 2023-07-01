import strformat, strutils

const Eps = 1e-10

type
  Matrix[M, N: static Positive] = array[M, array[N, float]]
  SquareMatrix[N: static Positive] = Matrix[N, N]


func toSquareMatrix[N: static Positive](a: array[N, array[N, int]]): SquareMatrix[N] =
  ## Convert a square matrix of integers to a square matrix of floats.

  for i in 0..<N:
    for j in 0..<N:
      result[i][j] = a[i][j].toFloat


func transformToRref(mat: var Matrix) =
  ## Transform a matrix to reduced row echelon form.

  var lead = 0

  for r in 0..<mat.M:

    if lead >= mat.N: return

    var i = r
    while mat[i][lead] == 0:
      inc i
      if i == mat.M:
        i = r
        inc lead
        if lead == mat.N: return
    swap mat[i], mat[r]

    let d = mat[r][lead]
    if abs(d) > Eps:    # Checking "d != 0" will give wrong results in some cases.
      for item in mat[r].mitems:
        item /= d

    for i in 0..<mat.M:
      if i != r:
        let m = mat[i][lead]
        for c in 0..<mat.N:
          mat[i][c] -= mat[r][c] * m

    inc lead


func inverse(mat: SquareMatrix): SquareMatrix[mat.N] =
  ## Return the inverse of a matrix.

  # Build augmented matrix.
  var augmat: Matrix[mat.N, 2 * mat.N]
  for i in 0..<mat.N:
    augmat[i][0..<mat.N] = mat[i]
    augmat[i][mat.N + i] = 1

  # Transform it to reduced row echelon form.
  augmat.transformToRref()

  # Check if the first half is the identity matrix and extract second half.
  for i in 0..<mat.N:
    for j in 0..<mat.N:
      if augmat[i][j] != float(i == j):
        raise newException(ValueError, "matrix is singular")
      result[i][j] = augmat[i][mat.N + j]


proc `$`(mat: Matrix): string =
  ## Display a matrix (which may be a square matrix).

  for row in mat:
    var line = ""
    for val in row:
      line.addSep(" ", 0)
      line.add &"{val:9.5f}"
    echo line


#———————————————————————————————————————————————————————————————————————————————————————————————————

template runTest(mat: SquareMatrix) =
  ## Run a test using square matrix "mat".

  echo "Matrix:"
  echo $mat
  echo "Inverse:"
  echo mat.inverse
  echo ""

let m1 = [[1, 2, 3],
          [4, 1, 6],
          [7, 8, 9]].toSquareMatrix()

let m2 = [[ 2, -1,  0],
          [-1,  2, -1],
          [ 0, -1,  2]].toSquareMatrix()

let m3 = [[ -1, -2,  3,  2],
          [ -4, -1,  6,  2],
          [  7, -8,  9,  1],
          [  1, -2,  1,  3]].toSquareMatrix()

runTest(m1)
runTest(m2)
runTest(m3)
