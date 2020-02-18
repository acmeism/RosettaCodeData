@inlinable
public func matrixTranspose<T>(_ matrix: [[T]]) -> [[T]] {
  guard !matrix.isEmpty else {
    return []
  }

  var ret = Array(repeating: [T](), count: matrix[0].count)

  for row in matrix {
    for j in 0..<row.count {
      ret[j].append(row[j])
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
  [1, 2, 3],
  [4, 5, 6]
]

print("Input:")
printMatrix(m1)


let m2 = matrixTranspose(m1)

print("Output:")
printMatrix(m2)
