: count-utf8 ( zstr -- n )
  0
  begin
    swap dup c@
  while
    utf8+
    swap 1+
  repeat drop ;
