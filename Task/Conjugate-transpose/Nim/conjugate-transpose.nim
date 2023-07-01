import complex, strformat

type Matrix[M, N: static Positive] = array[M, array[N, Complex[float]]]

const Eps = 1e-10   # Tolerance used for float comparisons.


####################################################################################################
# Templates.

template `[]`(m: Matrix; i, j: Natural): Complex[float] =
  ## Allow to get value of an element using m[i, j] syntax.
  m[i][j]

template `[]=`(m: var Matrix; i, j: Natural; val: Complex[float]) =
  ## Allow to set value of an element using m[i, j] syntax.
  m[i][j] = val


####################################################################################################
# General operations.

func `$`(m: Matrix): string =
  ## Return the string representation of a matrix using one line per row.

  for i, row in m:
    result.add(if i == 0: '[' else: ' ')
    for j, val in row:
      if j != 0: result.add(' ')
      result.add(&"({val.re:7.4f}, {val.im:7.4f})")
    result.add(if i == m.high: ']' else: '\n')

#---------------------------------------------------------------------------------------------------

func conjugateTransposed[M, N: static int](m: Matrix[M, N]): Matrix[N, M] =
  ## Return the conjugate transpose of a matrix.

  for i in 0..<m.M:
    for j in 0..<m.N:
      result[j, i] = m[i, j].conjugate()

#---------------------------------------------------------------------------------------------------

func `*`[M, K, N: static int](m1: Matrix[M, K]; m2: Matrix[K, N]): Matrix[M, N] =
  # Compute the product of two matrices.

  for i in 0..<M:
    for j in 0..<N:
      for k in 0..<K:
        result[i, j] = result[i, j] + m1[i, k] * m2[k, j]


####################################################################################################
# Properties.

func isHermitian(m: Matrix): bool =
  ## Check if a matrix is hermitian.

  when m.M != m.N:
    {.error: "hermitian test only allowed for square matrices".}
  else:
    for i in 0..<m.M:
      for j in i..<m.N:
        if m[i, j] != m[j, i].conjugate:
          return false
    result = true

#---------------------------------------------------------------------------------------------------

func isNormal(m: Matrix): bool =
  ## Check if a matrix is normal.

  when m.M != m.N:
    {.error: "normal test only allowed for square matrices".}
  else:
    let h = m.conjugateTransposed
    result = m * h == h * m

#---------------------------------------------------------------------------------------------------

func isIdentity(m: Matrix): bool =
  ## Check if a matrix is the identity matrix.

  when m.M != m.N:
    {.error: "identity test only allowed for square matrices".}
  else:
    for i in 0..<m.M:
      for j in 0..<m.N:
        if i == j:
          if abs(m[i, j] - 1.0) > Eps:
            return false
        else:
          if abs(m[i, j]) > Eps:
            return false
    result = true

#---------------------------------------------------------------------------------------------------

func isUnitary(m: Matrix): bool =
  ## Check if a matrix is unitary.

  when m.M != m.N:
    {.error: "unitary test only allowed for square matrices".}
  else:
    let h = m.conjugateTransposed
    result = (m * h).isIdentity and (h * m).isIdentity

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import math

  proc test(m: Matrix) =
    echo "\n"
    echo "Matrix"
    echo "------"
    echo m
    echo ""
    echo "Conjugate transposed"
    echo "--------------------"
    echo m.conjugateTransposed

    when m.M == m.N:
      # Only for squares matrices.
      echo ""
      echo "Hermitian: ", m.isHermitian
      echo "Normal: ", m.isNormal
      echo "Unitary: ", m.isUnitary

  #-------------------------------------------------------------------------------------------------

  # Non square matrix.
  const M1: Matrix[2, 3] = [[1.0 + im 2.0, 3.0 + im 0.0, 2.0 + im 5.0],
                            [3.0 - im 1.0, 2.0 + im 0.0, 0.0 + im 3.0]]

    # Square matrices.
  const M2: Matrix[2, 2] = [[3.0 + im 0.0, 2.0 + im 1.0],
                            [2.0 - im 1.0, 1.0 + im 0.0]]

  const M3: Matrix[3, 3] = [[1.0 + im 0.0, 1.0 + im 0.0, 0.0 + im 0.0],
                            [0.0 + im 0.0, 1.0 + im 0.0, 1.0 + im 0.0],
                            [1.0 + im 0.0, 0.0 + im 0.0, 1.0 + im 0.0]]

  const SR2 = 1 / sqrt(2.0)
  const M4: Matrix[3, 3] = [[SR2 + im 0.0, SR2 + im 0.0, 0.0 + im 0.0],
                            [0.0 + im SR2, 0.0 - im SR2, 0.0 + im 0.0],
                            [0.0 + im 0.0, 0.0 + im 0.0, 0.0 + im 1.0]]

  test(M1)
  test(M2)
  test(M3)
  test(M4)
