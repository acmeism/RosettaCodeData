def dotProduct = { x, y ->
    assert x && y && x.size() == y.size()
    [x, y].transpose().collect{ xx, yy -> xx * yy }.sum()
}
