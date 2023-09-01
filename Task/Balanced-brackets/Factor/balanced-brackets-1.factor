USING: combinators formatting kernel math random sequences strings ;
IN: rosetta-code.balanced-brackets

: balanced? ( str -- ? )
    0 swap [
        {
            { CHAR: [ [ 1 + t ] }
            { CHAR: ] [ 1 - dup 0 >= ] }
            [ drop t ]
        } case
    ] all? swap zero? and ;

: bracket-pairs ( n -- str )
    [ "[]" ] replicate "" concat-as ;

: balanced-brackets-main ( -- )
    5 bracket-pairs randomize dup balanced? "" "not " ?
    "String \"%s\" is %sbalanced.\n" printf ;

MAIN: balanced-brackets-main
