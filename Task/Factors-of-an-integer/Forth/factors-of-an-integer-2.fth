: sq  s" dup *" evaluate ; immediate

: factors ( n a xt -- )
    swap 2>r 1
    BEGIN 2dup sq > WHILE
        2dup /mod swap 0= IF
            over
            r> r@ execute
               r@ execute >r
        ELSE
            drop
        THEN 1+
    REPEAT
    2dup sq = IF
        2r> swap execute nip
    ELSE
        2drop r> rdrop
    THEN ;

: <with-factors>
    create 2, does> 2@ factors ;

0 :noname nip 1+ ; <with-factors> count-factors
0 ' + <with-factors> sum-factors

0 :noname swap . ; <with-factors> (.factors)
: .factors  (.factors) drop ;
