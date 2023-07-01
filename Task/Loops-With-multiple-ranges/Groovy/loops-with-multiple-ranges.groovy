def (prod, sum, x, y, z, one, three, seven) = [1, 0, +5, -5, -2, 1, 3, 7]

for (
    j in (
        ((-three) .. (3**3)       ).step(three)
      + ((-seven) .. (+seven)     ).step(x)
      + (555      .. (550-y)      )
      + (22       .. (-28)        ).step(three)    // This is correct!
      // Groovy interprets positive step size as stride through the LIST ELEMENTS as ordered
      // and negative step size as stride through the REVERSED LIST ELEMENTS as ordered
      //   so step(-3) gives:   -28, -25, -22, ... ,  20
      //   while step(3) gives:  22,  19,  16, ... , -26
      + (1927     .. 1939         )
      + (x        .. y            ).step(z)
      + (11**x    .. (11**x + one))
    )
) {

    sum = sum + j.abs()
    if ( prod.abs() < 2**27 && j != 0) prod *= j
}

println " sum= ${sum}"
println "prod= ${prod}"
