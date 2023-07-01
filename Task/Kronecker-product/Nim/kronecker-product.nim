import strutils

type Matrix[M, N: static Positive; T: SomeNumber] = array[M, array[N, T]]

func kroneckerProduct[M, N, P, Q: static int; T: SomeNumber](
  a: Matrix[M, N, T], b: Matrix[P, Q, T]): Matrix[M * P, N * Q, T] =
  for i in 0..<M:
    for j in 0..<N:
      for k in 0..<P:
        for l in 0..<Q:
          result[i * P + k][j * Q + l] = a[i][j] * b[k][l]

proc `$`(m: Matrix): string =
  for row in m:
    result.add '['
    let length = result.len
    for val in row:
      result.addSep(" ", length)
      result.add ($val).align(2)
    result.add "]\n"


when isMainModule:

  const
    A1: Matrix[2, 2, int] = [[1, 2], [3, 4]]
    B1: Matrix[2, 2, int] = [[0, 5], [6, 7]]

  echo "Matrix A:\n", A1
  echo "Matrix B:\n", B1
  echo "Kronecker product:\n", kroneckerProduct(A1, B1)

  const
    A2: Matrix[3, 3, int] = [[0, 1, 0], [1, 1, 1], [0, 1, 0]]
    B2: Matrix[3, 4, int] = [[1, 1, 1, 1], [1, 0, 0, 1], [1, 1, 1, 1]]

  echo "Matrix A:\n", A2
  echo "Matrix B:\n", B2
  echo "Kronecker product:\n", kroneckerProduct(A2, B2)
