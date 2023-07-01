printf ('    LIMIT       PRIMATIVE          ALL\n')
findPythagTriples().sort().each { perimeterLimit, result ->
    def exponent = perimeterLimit.toString().size() - 1
    printf ('a+b+c <= 10E%2d  %9d %12d\n', exponent, result.primative, result.total)
}
