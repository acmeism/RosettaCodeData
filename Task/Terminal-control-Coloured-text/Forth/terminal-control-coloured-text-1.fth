( ANSI terminal control lexicon Colored Text)
DECIMAL
( support routines)
 27 CONSTANT ESC
: <##>    ( n -- ) ( sends n, radix 10, no spaces)
          BASE @ >R   0 <# #S #> TYPE   R> BASE ! ;

: ESC[   ( -- )   ESC EMIT ." [" ;
( Attributes )
1 CONSTANT BOLD    2 CONSTANT DIM    3 CONSTANT ITALIC
5 CONSTANT BLINK   7 CONSTANT REV    8 CONSTANT BLANK

( Colors )
0 CONSTANT BLACK   1 CONSTANT RED    2 CONSTANT GREEN
3 CONSTANT YELLOW  4 CONSTANT BLUE   5 CONSTANT MAGENTA
6 CONSTANT CYAN    7 CONSTANT WHITE

: ATTR   ( attribute ) ESC[ <##> ." m" ;  ( use:  BOLD ATTR       )
: TEXT       ( color ) 30 + ATTR ;        ( use:  YELLOW TEXT     )
: BACKGROUND ( color ) 40 + ATTR ;        ( use:  BLUE BACKGROUND )
