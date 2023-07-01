type
  SquareMatrix[N: static Positive] = array[N, array[N, float]]
  Vector[N: static Positive] = array[N, float]


####################################################################################################
# Templates.

template `[]`(m: SquareMatrix; i, j: Natural): float =
  ## Allow to get value of an element using m[i, j] syntax.
  m[i][j]

template `[]=`(m: var SquareMatrix; i, j: Natural; val: float) =
  ## Allow to set value of an element using m[i, j] syntax.
  m[i][j] = val

#---------------------------------------------------------------------------------------------------

func det(m: SquareMatrix): float =
  ## Return the determinant of matrix "m".

  var m = m
  result = 1

  for j in 0..m.high:
    var imax = j
    for i in (j + 1)..m.high:
      if m[i, j] > m[imax, j]:
        imax = i

    if imax != j:
      swap m[iMax], m[j]
      result = -result

    if abs(m[j, j]) < 1e-12:
      return NaN

    for i in (j + 1)..m.high:
      let mult = -m[i, j] / m[j, j]
      for k in 0..m.high:
        m[i, k] += mult * m[j, k]

  for i in 0..m.high:
    result *= m[i, i]

#---------------------------------------------------------------------------------------------------

func cramerSolve(a: SquareMatrix; detA: float; b: Vector; col: Natural): float =
  ## Apply Cramer rule on matrix "a", using vector "b" to replace column "col".

  when a.N != b.N:
    {.error: "incompatible matrix and vector sizes".}

  else:
    var a = a
    for i in 0..a.high:
      a[i, col] = b[i]
    result = det(a) / detA

#———————————————————————————————————————————————————————————————————————————————————————————————————

import strformat

const

  A: SquareMatrix[4] = [[2.0, -1.0,  5.0,  1.0],
                        [3.0,  2.0,  2.0, -6.0],
                        [1.0,  3.0,  3.0, -1.0],
                        [5.0, -2.0, -3.0,  3.0]]

  B: Vector[4] = [-3.0, -32.0, -47.0, 49.0]

let detA = det(A)
if detA == NaN:
  echo "Singular matrix!"
  quit(QuitFailure)

for i in 0..A.high:
  echo &"{cramerSolve(A, detA, B, i):7.3f}"
