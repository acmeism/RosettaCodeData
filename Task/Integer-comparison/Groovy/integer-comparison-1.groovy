def comparison = { a, b ->
    println "a ? b    = ${a} ? ${b}    = a ${a < b ? '<' : a > b ? '>' : a == b ? '==' : '?'} b"
}
