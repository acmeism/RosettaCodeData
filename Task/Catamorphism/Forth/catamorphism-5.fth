: each-char ( c-addr u xt -- )
  {: xt :}  bounds ?do
    i c@ xt execute
  loop ;

: type-lowercase ( c-addr u -- )
  [: dup lowercase? if emit else drop then ;]
  each-char ;

\ producing a new string
: upcase ( 'string' -- 'STRING' )
  dup cell+ allocate throw -rot
  [: ( new-string-addr c -- new-string-addr )
    upcase over c+! ;] each-char  $@ ;

: count-lowercase ( c-addr u -- n )
  0 -rot [: lowercase? if 1+ then ;] each-char ;
