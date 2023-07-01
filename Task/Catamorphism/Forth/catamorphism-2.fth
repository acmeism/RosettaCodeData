: string-at ( c-addr u +n -- c )
  nip + c@ ;
: string-at! ( c-addr u +n c -- )
  rot drop  -rot  + c! ;

: type-lowercase ( c-addr u -- )
  dup 0 ?do
    2dup i string-at  dup lowercase?  if emit else drop then
  loop  2drop ;

: upcase ( 'string' -- 'STRING' )
  dup 0 ?do
    2dup 2dup  i string-at  char-upcase  i swap string-at!
  loop ;

: count-lowercase ( c-addr u -- n )
  0 -rot dup 0 ?do
    2dup i string-at  lowercase? if rot 1+ -rot then
  loop  2drop ;
