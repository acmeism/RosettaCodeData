type SquareMatrix[T: SomeNumber; N: static Positive] = array[N, array[N, T]]

func sumBelowDiagonal[T, N](m: SquareMatrix[T, N]): T =
  for i in 1..<N:
    for j in 0..<i:
      result += m[i][j]

const M = [[ 1,  3,  7,  8, 10],
           [ 2,  4, 16, 14,  4],
           [ 3,  1,  9, 18, 11],
           [12, 14, 17, 18, 20],
           [ 7,  1,  3,  9,  5]]

echo sumBelowDiagonal(M)
