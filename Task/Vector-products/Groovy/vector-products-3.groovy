def rotR = {
    assert it && it.size() > 2
    [it[-1]] + it[0..-2]
}

def rotL = {
    assert it && it.size() > 2
    it[1..-1] + [it[0]]
}

def pwSubtr = pairwiseOperation.rcurry { it[0] - it[1] }

def crossProductV = { x, y ->
    assert x && y && x.size() == 3 && y.size() == 3
    pwSubtr(pwMult(rotL(x), rotR(y)), pwMult(rotL(y), rotR(x)))
}
