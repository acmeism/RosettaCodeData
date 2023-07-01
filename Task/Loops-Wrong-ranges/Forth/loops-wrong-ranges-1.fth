: test-seq  ( start stop inc -- )
  cr rot dup ." start: " 2 .r
  rot dup ."  stop: " 2 .r
  rot dup ."  inc: " 2 .r ."  | "
  -rot swap do i . dup +loop drop ;
-2  2  1 test-seq
-2  2  0 test-seq
-2  2 -1 test-seq
-2  2 10 test-seq
 2 -2  1 test-seq
 2  2  1 test-seq
 2  2 -1 test-seq
 2  2  0 test-seq
 0  0  0 test-seq
