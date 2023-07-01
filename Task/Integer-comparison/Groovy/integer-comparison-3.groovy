final rels = [ (-1) : '<', 0 : '==', 1 : '>' ].asImmutable()
def comparisonSpaceship = { a, b ->
    println "a ? b    = ${a} ? ${b}    = a ${rels[a <=> b]} b"
}
