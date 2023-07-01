func identityMatrix(size: Int) -> [[Int]] {
  return (0..<size).map({i in
    return (0..<size).map({ $0 == i ? 1 : 0})
  })
}

print(identityMatrix(size: 5))
