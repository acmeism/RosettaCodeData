def dotProduct = { x, y ->
    assert x && y && x.size() == y.size()
    [x, y].transpose().collect{ it[0] * it[1] }.sum()
}
