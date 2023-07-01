def pairwiseOperation = { x, y, Closure binaryOp ->
    assert x && y && x.size() == y.size()
    [x, y].transpose().collect(binaryOp)
}

def pwMult =  pairwiseOperation.rcurry { it[0] * it[1] }

def dotProduct = { x, y ->
    assert x && y && x.size() == y.size()
    pwMult(x, y).sum()
}
