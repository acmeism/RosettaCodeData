(1..9).each { n ->
    def qds = queensDistinctSolutions(n)
    def qus = queensUniqueSolutions(qds)
    println ([boardSize:n, "number of distinct solutions":qds.size(), "number of unique solutions":qus.size()])
    if(n < 9) { qus.each { println it } }
    else { println "first:${qus[0]}"; println "last:${qus[-1]}" }
    println()
}
