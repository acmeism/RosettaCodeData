CONSTANT: roman-digits
    { "m" "cm" "d" "cd" "c" "xc" "l" "xl" "x" "ix" "v" "iv" "i" }

CONSTANT: roman-values
    { 1000 900 500 400 100 90 50 40 10 9 5 4 1 }

ERROR: roman-range-error n ;

: roman-range-check ( n -- n )
    dup 1 10000 between? [ roman-range-error ] unless ;

: >roman ( n -- str )
    roman-range-check
    roman-values roman-digits [
        [ /mod swap ] dip <repetition> concat
    ] 2map "" concat-as nip ;
