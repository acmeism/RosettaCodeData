: each-char[ ( c-addr u -- )
  postpone BOUNDS postpone ?DO
  postpone I postpone C@ ;  immediate

  \ interim code: ( c -- )

: ]each-char ( -- )
  postpone LOOP ;  immediate

: type-lowercase ( c-addr u -- )
  each-char[ dup lowercase? if emit else drop then ]each-char ;

: upcase ( 'string' -- 'STRING' )
  2dup each-char[ char-upcase i c! ]each-char ;

: count-lowercase ( c-addr u -- n )
  0 -rot each-char[ lowercase? if 1+ then ]each-char ;
