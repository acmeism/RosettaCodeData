def makeSwap = { a, i, j = i+1 -> print "."; a[[j,i]] = a[[i,j]] }

def checkSwap = { list, i, j = i+1 -> [(list[i] > list[j])].find{ it }.each { makeSwap(list, i, j) } }

def siftDown = { a, start, end ->
    def p = start
    while (p*2 < end) {
        def c = p*2 + ((p*2 + 1 < end && a[p*2 + 2] > a[p*2 + 1]) ? 2 : 1)
        if (checkSwap(a, c, p)) { p = c }
        else                    { return }
    }
}

def heapify = {
    (((it.size()-2).intdiv(2))..0).each { start -> siftDown(it, start, it.size()-1) }
}

def heapSort = { list ->
    heapify(list)
    (0..<(list.size())).reverse().each { end ->
        makeSwap(list, 0, end)
        siftDown(list, 0, end-1)
    }
    list
}
