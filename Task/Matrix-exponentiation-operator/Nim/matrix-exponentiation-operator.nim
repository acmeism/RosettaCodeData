import sequtils, strutils

type Matrix[N: static int; T] = array[1..N, array[1..N, T]]

func `*`[N, T](a, b: Matrix[N, T]): Matrix[N, T] =
  for i in 1..N:
    for j in 1..N:
      for k in 1..N:
        result[i][j] += a[i][k] * b[k][j]


func identityMatrix[N; T](): Matrix[N, T] =
  for i in 1..N:
    result[i][i] = T(1)


func `^`[N, T](m: Matrix[N, T]; n: Natural): Matrix[N, T] =
  if n == 0: return identityMatrix[N, T]()
  if n == 1: return m
  var n = n
  var m = m
  result = identityMatrix[N, T]()
  while n > 0:
    if (n and 1) != 0:
      result = result * m
    n = n shr 1
    m = m * m


proc `$`(m: Matrix): string =
  var lg = 0
  for i in 1..m.N:
    for j in 1..m.N:
      lg = max(lg, len($m[i][j]))
  for i in 1..m.N:
    echo m[i].mapIt(align($it, lg)).join(" ")


when isMainModule:

  let m1: Matrix[3, int] = [[ 3, 2, -1],
                            [-1, 0,  5],
                            [ 2, -1, 3]]
  echo m1^10

  import math
  const
    C30 = sqrt(3.0) / 2
    S30 = 1 / 2
  let m2: Matrix[2, float] = [[C30, -S30], [S30,  C30]]  # 30° rotation matrix.
  echo m2^12    # Nearly the identity matrix.
