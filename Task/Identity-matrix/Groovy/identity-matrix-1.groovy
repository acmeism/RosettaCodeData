def makeIdentityMatrix = { n ->
    (0..<n).collect { i -> (0..<n).collect { j -> (i == j) ? 1 : 0 } }
}
