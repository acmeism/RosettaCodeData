def arithmetic = { a, b ->
    println """
       a + b =        ${a} + ${b} = ${a + b}
       a - b =        ${a} - ${b} = ${a - b}
       a * b =        ${a} * ${b} = ${a * b}
       a / b =        ${a} / ${b} = ${a / b}   !!! Converts to floating point!
(int)(a / b) = (int)(${a} / ${b}) = ${(int)(a / b)}              !!! Truncates downward after the fact
 a.intdiv(b) =  ${a}.intdiv(${b}) = ${a.intdiv(b)}              !!! Behaves as if truncating downward, actual implementation varies
       a % b =        ${a} % ${b} = ${a % b}

Exponentiation is also a base arithmetic operation in Groovy, so:
      a ** b =       ${a} ** ${b} = ${a ** b}
"""
}
