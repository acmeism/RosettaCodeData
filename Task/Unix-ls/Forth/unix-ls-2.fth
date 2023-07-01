: save-string ( c-addr u -- a )
  dup 1+ allocate throw dup >r place r> ;

require ffl/car.fs
: sorted-filenames ( -- car )
  0 car-new { a }
  [: swap count rot count compare ;] a car-compare!
  each-filename[ save-string a car-insert-sorted ]each-filename
  a ;

: each-sorted-filename ( xt -- )
  sorted-filenames { a }  a car-execute  [: free throw ;] a car-execute  a car-free ;

: ls ( -- )
  [: count cr type ;] each-sorted-filename ;
