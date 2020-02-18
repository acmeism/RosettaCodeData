@inlinable
public func matrixMult<T: Numeric>(_ m1: [[T]], _ m2: [[T]]) -> [[T]] {
  let n = m1[0].count
  let m = m1.count
  let p = m2[0].count

  guard m != 0 else {
    return []
  }

  precondition(n == m2.count)

  var ret = Array(repeating: Array(repeating: T.zero, count: p), count: m)

  for i in 0..<m {
    for j in 0..<p {
      for k in 0..<n {
        ret[i][j] += m1[i][k] * m2[k][j]
      }
    }
  }

  return ret
}

@inlinable
public func printMatrix<T>(_ matrix: [[T]]) {
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

let m1 = [
  [6.5, 2, 3],
  [4.5, 1, 5]
]

let m2 = [
  [10.0, 16, 23, 50],
  [12, -8, 16, -4],
  [70, 60, -1, -2]
]

let m3 = matrixMult(m1, m2)

printMatrix(m3)
