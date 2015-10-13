USING: combinators io kernel math math.functions math.order
math.parser prettyprint ;

"a=" "b=" [ write readln string>number ] bi@
{
    [ + "sum: " write . ]
    [ - "difference: " write . ]
    [ * "product: " write . ]
    [ / "quotient: " write . ]
    [ /i "integer quotient: " write . ]
    [ rem "remainder: " write . ]
    [ mod "modulo: " write . ]
    [ max "maximum: " write . ]
    [ min "minimum: " write . ]
    [ gcd "gcd: " write . drop ]
    [ lcm "lcm: " write . ]
} 2cleave
