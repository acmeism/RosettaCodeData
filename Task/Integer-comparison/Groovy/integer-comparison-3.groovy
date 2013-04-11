def comparison = { a, b ->
    def rels = [ (-1) : '<', 0 : '==', 1 : '>' ]
    println "a ? b    = ${a} ? ${b}    = a ${rels[a <=> b]} b"
}
