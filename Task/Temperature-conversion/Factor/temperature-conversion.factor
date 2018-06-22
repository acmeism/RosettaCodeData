USING: combinators formatting kernel math ;
IN: rosetta-code.temperature

: k>c ( kelvin -- celsius )    273.15 - ;
: k>r ( kelvin -- rankine )    9/5 * ;
: k>f ( kelvin -- fahrenheit ) k>r 459.67 - ;

: convert ( kelvin -- )
    { [ ] [ k>c ] [ k>f ] [ k>r ] } cleave
    "K  %.2f\nC  %.2f\nF  %.2f\nR  %.2f\n" printf ;

21 convert
