import macros, strutils
import strfmt

type

  Matrix[M, N: static int] = array[1..M, array[1..N, float]]
  SquareMatrix[N: static int] = Matrix[N, N]


# Templates to allow to use more natural notation for indexing.
template `[]`(m: Matrix; i, j: int): float = m[i][j]
template `[]=`(m: Matrix; i, j: int; val: float) = m[i][j] = val


func `*`[M, N, P: static int](a: Matrix[M, N]; b: Matrix[N, P]): Matrix[M, P] =
  ## Matrix multiplication.
  for i in 1..M:
    for j in 1..P:
      for k in 1..N:
        result[i, j] += a[i, k] * b[k, j]


func pivotize[N: static int](m: SquareMatrix[N]): SquareMatrix[N] =

  for i in 1..N: result[i, i] = 1

  for i in 1..N:
    var max = m[i, i]
    var row = i
    for j in i..N:
      if m[j, i] > max:
        max = m[j, i]
        row = j
    if i != row:
      swap result[i], result[row]


func lu[N: static int](m: SquareMatrix[N]): tuple[l, u, p: SquareMatrix[N]] =

  result.p = m.pivotize()
  let m2 = result.p * m

  for j in 1..N:
    result.l[j, j] = 1
    for i in 1..j:
      var sum = 0.0
      for k in 1..<i: sum += result.u[k, j] * result.l[i, k]
      result.u[i, j] = m2[i, j] - sum
    for i in j..N:
      var sum = 0.0
      for k in 1..<j: sum += result.u[k, j] * result.l[i, k]
      result.l[i, j] = (m2[i, j] - sum) / result.u[j, j]


proc print(m: Matrix; title, f: string) =
  echo '\n', title
  for i in 1..m.N:
    for j in 1..m.N:
      stdout.write m[i, j].format(f), "  "
    stdout.write '\n'


when isMainModule:

  const A1: SquareMatrix[3] = [[1.0, 3.0, 5.0],
                               [2.0, 4.0, 7.0],
                               [1.0, 1.0, 0.0]]

  let (l1, u1, p1) = A1.lu()
  echo "\nExample 2:"
  A1.print("A:", "1.0f")
  l1.print("L:", "8.5f")
  u1.print("U:", "8.5f")
  p1.print("P:", "1.0f")


  const A2: SquareMatrix[4] = [[11.0,  9.0, 24.0,  2.0],
                               [ 1.0,  5.0,  2.0,  6.0],
                               [ 3.0, 17.0, 18.0,  1.0],
                               [ 2.0,  5.0,  7.0,  1.0]]

  let (l2, u2, p2) = A2.lu()
  echo "Example 1:"
  A2.print("A:", "2.0f")
  l2.print("L:", "8.5f")
  u2.print("U:", "8.5f")
  p2.print("P:", "1.0f")
