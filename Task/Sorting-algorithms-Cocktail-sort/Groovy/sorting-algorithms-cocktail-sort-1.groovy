def makeSwap = { a, i, j = i+1 -> print "."; a[[j,i]] = a[[i,j]] }

def checkSwap = { a, i, j = i+1 -> [(a[i] > a[j])].find{ it }.each { makeSwap(a, i, j) } }

def cocktailSort = { list ->
    if (list == null || list.size() < 2) return list
    def n = list.size()
    def swap = checkSwap.curry(list)
    while (true) {
        def swapped = (0..(n-2)).any(swap) && ((-2)..(-n)).any(swap)
        if ( ! swapped ) break
    }
    list
}
