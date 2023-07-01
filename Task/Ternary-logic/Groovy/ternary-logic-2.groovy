printf 'AND\n         '
Trit.values().each { b -> printf ('%6s', b) }
println '\n          ----- ----- -----'
Trit.values().each { a ->
    printf ('%6s | ', a)
    Trit.values().each { b -> printf ('%6s', a.and(b)) }
    println()
}

printf '\nOR\n         '
Trit.values().each { b -> printf ('%6s', b) }
println '\n          ----- ----- -----'
Trit.values().each { a ->
    printf ('%6s | ', a)
    Trit.values().each { b -> printf ('%6s', a.or(b)) }
    println()
}

println '\nNOT'
Trit.values().each {
    printf ('%6s | %6s\n', it, it.not())
}

printf '\nIMPLY\n         '
Trit.values().each { b -> printf ('%6s', b) }
println '\n          ----- ----- -----'
Trit.values().each { a ->
    printf ('%6s | ', a)
    Trit.values().each { b -> printf ('%6s', a.imply(b)) }
    println()
}

printf '\nEQUIV\n         '
Trit.values().each { b -> printf ('%6s', b) }
println '\n          ----- ----- -----'
Trit.values().each { a ->
    printf ('%6s | ', a)
    Trit.values().each { b -> printf ('%6s', a.equiv(b)) }
    println()
}
