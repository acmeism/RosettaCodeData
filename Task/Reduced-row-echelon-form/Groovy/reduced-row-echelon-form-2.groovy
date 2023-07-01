def matrixCopy = { matrix -> matrix.collect { row -> row.collect { it } } }

println "Tests for matrix A:"
def a = [
    [1, 2, -1, -4],
    [2, 3, -1, -11],
    [-2, 0, -3, 22]
]
a.each { println it }
println()

println "pivoting == Pivoting.NONE"
reducedRowEchelonForm(matrixCopy(a)).each { println it }
println()
println "pivoting == Pivoting.PARTIAL"
reducedRowEchelonForm(matrixCopy(a), Pivoting.PARTIAL).each { println it }
println()
println "pivoting == Pivoting.SCALED"
reducedRowEchelonForm(matrixCopy(a), Pivoting.SCALED).each { println it }
println()


println "Tests for matrix B (divides by 0 without pivoting):"
def b = [
    [1, 2, -1, -4],
    [2, 4, -1, -11],
    [-2, 0, -6, 24]
]
b.each { println it }
println()

println "pivoting == Pivoting.NONE"
try {
    reducedRowEchelonForm(matrixCopy(b)).each { println it }
    println()
} catch (e) {
    println "KABOOM! ${e.message}"
    println()
}

println "pivoting == Pivoting.PARTIAL"
reducedRowEchelonForm(matrixCopy(b), Pivoting.PARTIAL).each { println it }
println()
println "pivoting == Pivoting.SCALED"
reducedRowEchelonForm(matrixCopy(b), Pivoting.SCALED).each { println it }
println()
