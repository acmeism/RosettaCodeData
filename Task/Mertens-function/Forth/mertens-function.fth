: AMOUNT 1000 ;

variable mertens AMOUNT cells allot
: M 1- cells mertens + ; \ 1-indexed array

: make-mertens
  1 1 M !
  2 begin dup AMOUNT <= while
    1 over M !
    2 begin over over >= while
      over over / M @
      2 pick M @ swap -
      2 pick M !
    1+ repeat
    drop
  1+ repeat
  drop
;

: print-row
  begin dup while
    swap dup M @ 3 .r 1+
    swap 1-
  repeat
  drop
;

: print-table ."    "
  1 9 print-row cr
  begin dup 100 < while 10 print-row cr repeat
  drop
;

: find-zero-cross
  0 0
  1 begin dup AMOUNT <= while
    dup M @ 0= if
      swap 1+ swap
      dup 1- M @ 0<> if rot 1+ -rot then
    then
    1+
  repeat
  drop
;

make-mertens
." The first 99 Mertens numbers are:" cr print-table
find-zero-cross
." M(N) is zero " . ." times." cr
." M(N) crosses zero " . ." times." cr
bye
