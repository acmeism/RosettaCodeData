import rationals, strutils

type Fraction = Rational[int]

const Zero: Fraction = 0 // 1

type Matrix[M, N: static Positive] = array[M, array[N, Fraction]]


func toMatrix[M, N: static Positive](a: array[M, array[N, int]]): Matrix[M, N] =
  ## Convert a matrix of integers to a matrix of integer fractions.

  for i in 0..<M:
    for j in 0..<N:
      result[i][j] = a[i][j] // 1


func transformToRref(mat: var Matrix) =
  ## Transform the given matrix to reduced row echelon form.

  var lead = 0

  for r in 0..<mat.M:

    if lead >= mat.N: return

    var i = r
    while mat[i][lead] == Zero:
      inc i
      if i == mat.M:
        i = r
        inc lead
        if lead == mat.N: return
    swap mat[i], mat[r]

    if (let d = mat[r][lead]; d) != Zero:
      for item in mat[r].mitems:
        item /= d

    for i in 0..<mat.M:
      if i != r:
        let m = mat[i][lead]
        for c in 0..<mat.N:
          mat[i][c] -= mat[r][c] * m

    inc lead


proc `$`(mat: Matrix): string =
  ## Display a matrix.

  for row in mat:
    var line = ""
    for val in row:
      line.addSep(" ", 0)
      line.add val.toFloat.formatFloat(ffDecimal, 2).align(7)
    echo line


#———————————————————————————————————————————————————————————————————————————————————————————————————

template runTest(mat: Matrix) =
  ## Run a test using matrix "mat".

  echo "Original matrix:"
  echo mat
  echo "Reduced row echelon form:"
  mat.transformToRref()
  echo mat
  echo ""


var m1 = [[ 1, 2, -1,  -4],
          [ 2, 3, -1, -11],
          [-2, 0, -3,  22]].toMatrix()

var m2 = [[2, 0, -1,  0,  0],
          [1, 0,  0, -1,  0],
          [3, 0,  0, -2, -1],
          [0, 1,  0,  0, -2],
          [0, 1, -1,  0,  0]].toMatrix()

var m3 = [[1,  2,  3,  4,  3,  1],
          [2,  4,  6,  2,  6,  2],
          [3,  6, 18,  9,  9, -6],
          [4,  8, 12, 10, 12,  4],
          [5, 10, 24, 11, 15, -4]].toMatrix()

var m4 = [[0, 1],
          [1, 2],
          [0, 5]].toMatrix()

runTest(m1)
runTest(m2)
runTest(m3)
runTest(m4)
