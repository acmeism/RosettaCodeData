def makeSwap = { a, i, j = i+1 -> print "."; a[[i,j]] = a[[j,i]] }

def checkSwap = { a, i, j = i+1 -> [(a[i] > a[j])].find { it }.each { makeSwap(a, i, j) } }

def bubbleSort = { list ->
    boolean swapped = true
    while (swapped) { swapped = (1..<list.size()).any { checkSwap(list, it-1) } }
    list
}
