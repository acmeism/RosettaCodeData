: comma-list ( n -- )
  1
  begin  dup 1 .r
         2dup <>
  while  ." , " 1+
  repeat 2drop ;
