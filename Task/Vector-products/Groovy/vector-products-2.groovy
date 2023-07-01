def crossProductS = { x, y ->
    assert x && y && x.size() == 3 && y.size() == 3
    [x[1]*y[2] - x[2]*y[1], x[2]*y[0] - x[0]*y[2] , x[0]*y[1] - x[1]*y[0]]
}
