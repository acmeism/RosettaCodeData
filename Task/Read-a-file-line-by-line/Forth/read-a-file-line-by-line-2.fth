: read-lines' ( max addr len -- )
  r/w open-file throw >r
  begin
    pad over r@ read-line throw
  while
    pad swap  ( c-addr u )
    cr type
  repeat r> close-file throw 2drop ;

4096 s" /Users/johnSmith/input.f" read-lines'
