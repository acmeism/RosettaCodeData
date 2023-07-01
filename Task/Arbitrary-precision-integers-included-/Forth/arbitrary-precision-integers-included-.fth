INCLUDE big.fth

big_digit_pointer *exp              \ iteration counter
big_digit_pointer *base             \ point to base of number being exponentiated

big_digit_pointer *0                \ store 0
big_digit_pointer *1                \ store 1
big_digit_pointer *result           \ point to result of exponentiation
big_digit_pointer *temp             \ point to temporary result

: big--                             ( addr-n -- )
    DUP 0 *1 big-                   ( addr-n addr-n-1 ) \ decrement value
    SWAP DUP @ ABS 1+ CELLS MOVE    ( ) \ overwrite addr-n with addr-n-1
;

: big>                              ( addr1 addr2 -- flag )
    2DUP big< >R                    ( addr1 addr2 ) ( R: flag1 )
    big=                            ( flag2 ) ( R: flag1 )
    R> OR 0=                        ( ! <= )
;

: big^                              ( addr-base addr-exp - addr )
    to_pointer *exp
    to_pointer *base

    HERE 1 , 0 , to_pointer *0      \ create limit value for counter
    HERE 1 , 1 , to_pointer *1      \ create subtraend for counter
    HERE 1 , 1 , to_pointer *result \ create result = 1
    BEGIN
        0 *exp 0 *0 big>            ( flag ) \ loop while exp > 0
        0 *exp big--                \ prepare for next iteration
    WHILE
        0 *result 0 *base big*
        to_pointer *temp            \ temp = result * base

        0 *temp 0 *result
        reposition                  \ move [temp,HERE[ to [result,result+size[
    REPEAT
    0 *result 0 *0
    reposition                      \ overwrite *0 with result
    0 *0                            \ and return its address
;

: big-show                          ( addr -- )
    \ show first 20 and last 20 digits of the big number
    <big# big#s #big>               ( addr n )  \ returns string
    DUP . ."  digits" CR            \ show number of digits
    DUP 50 > IF
        OVER 20 TYPE ." ..."        \ show first 20 digits
        + 20 - 20 TYPE CR           \ show last 20 digits
    ELSE
        TYPE CR
    THEN
;

\ compute 5^(4^(3^2))
big 5 big 4 big 3 big 2 big^ big^ big^ big-show CR
