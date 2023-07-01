proc transpose[X, Y; T](s: array[Y, array[X, T]]): array[X, array[Y, T]] =
  for i in low(X)..high(X):
    for j in low(Y)..high(Y):
      result[i][j] = s[j][i]

let b = [[ 0, 1, 2, 3, 4],
         [ 5, 6, 7, 8, 9],
         [ 1, 0, 0, 0,42]]
let c = transpose(b)
for r in c:
  for i in r:
    stdout.write i, " "
  echo ""
