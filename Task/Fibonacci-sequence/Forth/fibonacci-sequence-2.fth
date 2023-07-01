: fib ( n -- Fn ) 0 1 begin
  rot dup 0 = if drop drop exit then
  dup 0 > if   1 - rot rot dup rot +
          else 1 + rot rot over - swap then
again ;
