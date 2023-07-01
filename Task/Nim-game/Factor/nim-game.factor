USING: interpolate io kernel math math.parser sequences ;
IN: rosetta-code.nim-game

: get-input ( -- n )
    "Number of tokens to take (1, 2, or 3): " write readln
    string>number dup { 1 2 3 } member?
    [ drop "Invalid move." print get-input ] unless ;

: .remaining ( n -- )
    nl [I -~~==[ ${} tokens remaining ]==~~-I] nl nl ;

: .choice ( str n -- )
    dup 1 = "" "s" ? [I ${} took ${} token${}I] nl ;

: (round) ( -- )
    "You" get-input "Computer" 4 pick - [ .choice ] 2bi@ ;

: round ( n -- n-4 )
    dup dup .remaining [ drop (round) 4 - round ] unless-zero ;

: nim-game ( -- ) 12 round drop "Computer wins!" print ;

MAIN: nim-game
