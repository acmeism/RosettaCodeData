[[30, 2], [30, 10], [1, 10], [12345, 10], [123405, 10], [0xfe, 16], [0xf0e, 16]].each {
    println """
    Decimal value:     ${it[0]}
    Radix:             ${it[1]}
    Radix value:       ${Integer.toString(it[0], it[1])}
    Decimal Digit Sum: ${digitsum(it[0], it[1])}
    Radix Digit Sum:   ${Integer.toString(digitsum(it[0], it[1]), it[1])}
    """
}
