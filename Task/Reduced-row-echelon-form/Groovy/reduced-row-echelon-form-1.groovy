enum Pivoting {
    NONE({ i, it -> 1 }),
    PARTIAL({ i, it -> - (it[i].abs()) }),
    SCALED({ i, it -> - it[i].abs()/(it.inject(0) { sum, elt -> sum + elt.abs() } ) });

    public final Closure comparer

    private Pivoting(Closure c) {
        comparer = c
    }
}

def isReducibleMatrix = { matrix ->
    def m = matrix.size()
    m > 1 && matrix[0].size() > m && matrix[1..<m].every { row -> row.size() == matrix[0].size() }
}

def reducedRowEchelonForm = { matrix, Pivoting pivoting = Pivoting.NONE ->
    assert isReducibleMatrix(matrix)
    def m = matrix.size()
    def n = matrix[0].size()
    (0..<m).each { i ->
        matrix[i..<m].sort(pivoting.comparer.curry(i))
        matrix[i][i..<n] = matrix[i][i..<n].collect { it/matrix[i][i] }
        ((0..<i) + ((i+1)..<m)).each { k ->
            (i..<n).reverse().each { j ->
                matrix[k][j] -= matrix[i][j]*matrix[k][i]
            }
        }
    }
    matrix
}
