def bitwise = { a, b ->
    println """
a & b   = ${a} & ${b}   = ${a & b}
a | b   = ${a} | ${b}   = ${a | b}
a ^ b   = ${a} ^ ${b}   = ${a ^ b}
~ a     = ~ ${a}     = ${~ a}
a << b  = ${a} << ${b}  = ${a << b}
a >> b  = ${a} >> ${b}  = ${a >> b}         arithmetic (sign-preserving) shift
a >>> b = ${a} >>> ${b} = ${a >>> b}  logical (zero-filling) shift
"""
}
