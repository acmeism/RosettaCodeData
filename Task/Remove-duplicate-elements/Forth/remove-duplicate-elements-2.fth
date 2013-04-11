: uniqv { a n \ r e -- n }
    a n cells+ to e
    a dup to r
    \ the write address lives on the stack
    begin
      r e <
    while
      r @ over !
      r cell+ e skip-dups to r
      cell+
    repeat
    a - cell / ;
