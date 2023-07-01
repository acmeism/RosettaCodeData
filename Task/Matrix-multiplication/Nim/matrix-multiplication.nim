import strfmt

type Matrix[M, N: static[int]] = array[M, array[N, float]]

let a = [[1.0,  1.0,  1.0,   1.0],
         [2.0,  4.0,  8.0,  16.0],
         [3.0,  9.0, 27.0,  81.0],
         [4.0, 16.0, 64.0, 256.0]]

let b = [[    4.0, -3.0  ,  4/3.0,   -1/4.0],
         [-13/3.0, 19/4.0, -7/3.0,  11/24.0],
         [  3/2.0, -2.0  ,  7/6.0,   -1/4.0],
         [ -1/6.0,  1/4.0, -1/6.0,   1/24.0]]

proc `$`(m: Matrix): string =
  result = "(["
  for r in m:
    if result.len > 2: result.add "]\n ["
    for val in r: result.add val.format("8.2f")
  result.add "])"

proc `*`[M, P, N](a: Matrix[M, P]; b: Matrix[P, N]): Matrix[M, N] =
  for i in result.low .. result.high:
    for j in result[0].low .. result[0].high:
      for k in a[0].low .. a[0].high:
        result[i][j] += a[i][k] * b[k][j]

echo a
echo b
echo a * b
echo b * a
