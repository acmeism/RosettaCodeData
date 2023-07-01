#! /usr/bin/env factor

USING: kernel io ascii math combinators sequences ;
IN: rot13

: rot-base ( ch ch -- ch ) [ - 13 + 26 mod ] keep + ;

: rot13-ch ( ch -- ch )
    {
        { [ dup letter? ] [ CHAR: a rot-base ] }
        { [ dup LETTER? ] [ CHAR: A rot-base ] }
        [ ]
    }
    cond ;

: rot13 ( str -- str ) [ rot13-ch ] map ;

: main ( -- )
    [ readln dup ]
    [ rot13 print flush ]
    while
    drop ;

MAIN: main
