( ANSI terminal control lexicon )
DECIMAL

( support routines)
 27 CONSTANT ESC
: <##>    ( n -- ) ( sends n, radix 10, no spaces)
          BASE @ >R DECIMAL  0 <# #S #> TYPE   R> BASE ! ;

: ESC[   ( -- )   ESC EMIT ." [" ;

( ANSI terminal commands as Forth words)
: <CUU>  ( row --) ESC[ <##> ." A" ;
: <CUD>  ( row --) ESC[ <##> ." B" ;
: <CUF>  ( col --) ESC[ <##> ." C" ;
: <CUB>  ( col --) ESC[ <##> ." D" ;
: <CPL>  ( -- )    ESC[ <##> ." F" ;
: <CHA>  ( n --)   ESC[ <##> ." G" ;
: <EL>   ( -- )    ESC[ ." K" ;
: <ED>   ( -- )    ESC[ ." 2J" ;
: <CUP>  ( row col -- ) SWAP ESC[ <##> ." ;" <##> ." H"  ;

( Define ANSI Forth names for these functions using our markup words)
: AT-XY ( col row  -- ) SWAP <CUP> ;
: PAGE  ( -- ) <ED>  1 1 <CUP> ;
