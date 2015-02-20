class Triple {
    BigInteger a, b, c
    def getPerimeter() { this.with { a + b + c } }
    boolean isValid() { this.with { a*a + b*b == c*c } }
}

def initCounts (def n = 10) {
    (n..1).collect { 10g**it }.inject ([:]) { Map map, BigInteger perimeterLimit ->
        map << [(perimeterLimit): [primative: 0g, total: 0g]]
    }
}

def findPythagTriples, findChildTriples

findPythagTriples = {Triple t = new Triple(a:3, b:4, c:5), Map counts = initCounts() ->
    def p = t.perimeter
    def currentCounts = counts.findAll { pLimit, tripleCounts -> p <= pLimit }
    if (! currentCounts || ! t.valid) { return }
    currentCounts.each { pLimit, tripleCounts ->
        tripleCounts.with { primative ++; total += pLimit.intdiv(p) }
    }
    findChildTriples(t, currentCounts)
    counts
}

findChildTriples = { Triple t, Map counts ->
    t.with {
        [
            [ a - 2*b + 2*c,  2*a - b + 2*c,  2*a - 2*b + 3*c],
            [ a + 2*b + 2*c,  2*a + b + 2*c,  2*a + 2*b + 3*c],
            [-a + 2*b + 2*c, -2*a + b + 2*c, -2*a + 2*b + 3*c]
        ]*.sort().each { aa, bb, cc ->
            findPythagTriples(new Triple(a:aa, b:bb, c:cc), counts)
        }
    }
}
