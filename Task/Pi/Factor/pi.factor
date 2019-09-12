USING: combinators.extras io kernel locals math prettyprint ;
IN: rosetta-code.pi

:: calc-pi-digits ( -- )
    1 0 1 1 3 3 :> ( q! r! t! k! n! l! ) [
        4 q * r + t - n t * < [
            n pprint flush
            r n t * - 10 *
            3 q * r + 10 * t /i n 10 * - n! r!
            q 10 * q!
        ] [
            2 q * r + l *
            7 k * q * 2 + r l * + t l * /i n! r!
            k q * q!
            t l * t!
            l 2 + l!
            k 1 + k!
        ] if
    ] forever ;

MAIN: calc-pi-digits
