def matmulWOT = { a, b ->
    assertConformable(a, b)

    (0..<a.size()).collect { i ->
        (0..<b[0].size()).collect { j ->
            (0..<b.size()).collect { k -> a[i][k] * b[k][j] }.sum()
        }
    }
}
