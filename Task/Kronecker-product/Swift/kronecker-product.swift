func kronecker(m1: [[Int]], m2: [[Int]]) -> [[Int]] {
  let m = m1.count
  let n = m1[0].count
  let p = m2.count
  let q = m2[0].count
  let rtn = m * p
  let ctn = n * q

  var res = Array(repeating: Array(repeating: 0, count: ctn), count: rtn)

  for i in 0..<m {
    for j in 0..<n {
      for k in 0..<p {
        for l in 0..<q {
          res[p * i + k][q * j + l] = m1[i][j] * m2[k][l]
        }
      }
    }
  }

  return res
}

func printMatrix<T>(_ matrix: [[T]]) {
  guard !matrix.isEmpty else {
    print()

    return
  }

  let rows = matrix.count
  let cols = matrix[0].count

  for i in 0..<rows {
    for j in 0..<cols {
      print(matrix[i][j], terminator: " ")
    }

    print()
  }
}


func printProducts(a: [[Int]], b: [[Int]]) {
  print("Matrix A:")
  printMatrix(a)
  print("Matrix B:")
  printMatrix(b)
  print("kronecker a b:")
  printMatrix(kronecker(m1: a, m2: b))
  print()
}

let a = [
  [1, 2],
  [3, 4]
]

let b = [
  [0, 5],
  [6, 7]
]

printProducts(a: a, b: b)

let a2 = [
  [0, 1, 0],
  [1, 1, 1],
  [0, 1, 0]
]

let b2 = [
  [1, 1, 1, 1],
  [1, 0, 0, 1],
  [1, 1, 1, 1]
]

printProducts(a: a2, b: b2)
