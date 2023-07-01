def listSwap = { a, i, j ->
    assert (0..<(a.size())).containsAll([i,j]);
    a[[j,i]] = a[[i,j]]
}

def list = [2,4,6,8]
listSwap(list, 1, 3)
assert list == [2,8,6,4]
