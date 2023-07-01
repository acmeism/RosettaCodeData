import math, strutils, strformat

type Matrix[N: static int, T: SomeFloat] = array[N, array[N, T]]

proc cholesky[Matrix](a: Matrix): Matrix =
  for i in 0 ..< a[0].len:
    for j in 0 .. i:
      var s = 0.0
      for k in 0 ..< j:
        s += result[i][k] * result[j][k]
      result[i][j] = if i == j: sqrt(a[i][i]-s)
                     else: 1.0 / result[j][j] * (a[i][j] - s)

proc `$`(a: Matrix): string =
  result = ""
  for b in a:
    var line = ""
    for c in b:
      line.addSep(" ", 0)
      line.add fmt"{c:8.5f}"
    result.add line & '\n'

let m1 = [[25.0, 15.0, -5.0],
          [15.0, 18.0,  0.0],
          [-5.0,  0.0, 11.0]]
echo cholesky(m1)

let m2 = [[18.0, 22.0,  54.0,  42.0],
          [22.0, 70.0,  86.0,  62.0],
          [54.0, 86.0, 174.0, 134.0],
          [42.0, 62.0, 134.0, 106.0]]
echo cholesky(m2)
