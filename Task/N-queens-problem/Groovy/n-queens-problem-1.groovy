def listOrder = { a, b ->
    def k = [a.size(), b.size()].min()
    def i = (0..<k).find { a[it] != b[it] }
    (i != null) ? a[i] <=> b[i] : a.size() <=> b.size()
}

def orderedPermutations = { list ->
    def n = list.size()
    (0..<n).permutations().sort(listOrder)
}

def diagonalSafe = { list ->
    def n = list.size()
    n == 1 || (0..<(n-1)).every{ i ->
        ((i+1)..<n).every{ j ->
            !([list[i]+j-i, list[i]+i-j].contains(list[j]))
        }
    }
}

def queensDistinctSolutions = { n ->
    // each permutation is an N-Rooks solution
    orderedPermutations((0..<n)).findAll (diagonalSafe)
}
