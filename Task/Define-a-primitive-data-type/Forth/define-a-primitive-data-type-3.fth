DECIMAL
: FAST!   ( n addr -- )  ! ;   ( alias the standard version)

DEFER !

\ commands to change the action of '!'
: LIMITS-ON   ( -- ) ['] SAFE! IS ! ;
: LIMITS-OFF  ( -- ) ['] FAST! IS ! ;
: CLIPPING-ON ( -- ) ['] CLIP! IS ! ;
