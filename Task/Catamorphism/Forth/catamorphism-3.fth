: next-char ( a +n -- a' n' c -1 )  ( a 0 -- 0 )
  dup if 2dup  1 /string  2swap drop c@ true
  else 2drop 0 then ;

: type-lowercase ( c-addr u -- )
  begin next-char while
    dup lowercase? if emit else drop then
  repeat ;
