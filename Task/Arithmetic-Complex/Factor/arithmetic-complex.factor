USING: combinators kernel math math.functions prettyprint ;

C{ 1 2 } C{ 0.9 -2.78 } {
    [ + . ]             ! addition
    [ - . ]             ! subtraction
    [ * . ]             ! multiplication
    [ / . ]             ! division
    [ ^ . ]             ! power
} 2cleave

C{ 1 2 } {
    [ neg . ]           ! negation
    [ recip . ]         ! multiplicative inverse
    [ conjugate . ]     ! complex conjugate
    [ sin . ]           ! sine
    [ log . ]           ! natural logarithm
    [ sqrt . ]          ! square root
} cleave
