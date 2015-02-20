['{}': [], '{ABC}': ['ABC'], '{ABC and DEF}': ['ABC', 'DEF'], '{ABC, DEF, G and H}': ['ABC', 'DEF', 'G', 'H']].each { expected, input ->
    println "Verifying commaQuibbling($input) == $expected"
    assert commaQuibbling(input) == expected
}
