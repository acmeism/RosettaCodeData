Set brackets = []
(0..100).each {
    (0..8).each { r ->
        brackets << randomBrackets(r)
    }
}

brackets.sort { a, b ->
    a.size() <=> b.size() ?: a <=> b
} .each {
    def bal = balancedBrackets(it) ? "balanced:   " : "unbalanced: "
    println "${bal} ${it}"
}
