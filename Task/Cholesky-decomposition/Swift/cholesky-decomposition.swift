func cholesky(matrix: [Double], n: Int) -> [Double] {
  var res = [Double](repeating: 0, count: matrix.count)

  for i in 0..<n {
    for j in 0..<i+1 {
      var s = 0.0

      for k in 0..<j {
        s += res[i * n + k] * res[j * n + k]
      }

      if i == j {
        res[i * n + j] = (matrix[i * n + i] - s).squareRoot()
      } else {
        res[i * n + j] = (1.0 / res[j * n + j] * (matrix[i * n + j] - s))
      }
    }
  }

  return res
}

func printMatrix(_ matrix: [Double], n: Int) {
  for i in 0..<n {
    for j in 0..<n {
      print(matrix[i * n + j], terminator: " ")
    }

    print()
  }
}

let res1 = cholesky(
  matrix: [25.0, 15.0, -5.0,
           15.0, 18.0,  0.0,
           -5.0,  0.0, 11.0],
  n: 3
)

let res2 = cholesky(
  matrix: [18.0, 22.0,  54.0,  42.0,
           22.0, 70.0,  86.0,  62.0,
           54.0, 86.0, 174.0, 134.0,
           42.0, 62.0, 134.0, 106.0],
  n: 4
)

printMatrix(res1, n: 3)
print()
printMatrix(res2, n: 4)
