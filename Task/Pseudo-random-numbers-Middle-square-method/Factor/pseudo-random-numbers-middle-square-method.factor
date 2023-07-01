USING: kernel math namespaces prettyprint ;

SYMBOL: seed
675248 seed set-global

: rand ( -- n ) seed get sq 1000 /i 1000000 mod dup seed set ;

5 [ rand . ] times
