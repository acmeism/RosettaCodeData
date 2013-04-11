def makeSwap = { a, i, j = i+1 -> print "."; a[[j,i]] = a[[i,j]] }

def flip = { list, n -> (0..<((n+1)/2)).each { makeSwap(list, it, n-it) } }

def pancakeSort = { list ->
    def n = list.size()
    (1..<n).reverse().each { i ->
        def max = list[0..i].max()
        def flipPoint = (i..0).find{ list[it] == max }
        if (flipPoint != i) {
            flip(list, flipPoint)
            flip(list, i)
        }
    }
    list
}
