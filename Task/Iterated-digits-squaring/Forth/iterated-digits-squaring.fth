Tested for VFX Forth and GForth in Linux
\ To explain the algorithm: Each iteration is performed in set-count-sumsq below.
\ sum square of digits for 1 digit numbers are
\   Base   1  2  3  4  5  6  7  8  9
\   Sumsq: 1  4  9 16 25 36 49 54 81
\ Adding 10 to the base adds 1 to the sumsq,
\ Adding 20 to the base adds 4
\         ||
\ Adding 90 adds 81
\ Similarly for n00, n000 etc..

\ Worked example for base 3 ( to keep the lists short ).
\ The base 10 version performs 1.1 .. 1.9  with shifts of 1, 4, 9 .. 81 cells
\
\    Ix      0   1   2   3   4   5   6   7   8
\    0     [ 1 ]
\    1.1       [ 1 ]                               Previous result shifted 1 cell ( 1**2 )
\    1.2                   [ 1 ]                   Previous result shifted 4 cells ( 2** 2 )
\    ------------------------------
\    Sum   [ 1,  1,  0,  0,  1  ]
\    2.1       [ 1,  1,  0,  0,  1  ]              Previous result shifted 1 cell ( 1**2 )
\    2.2                   [ 1,  1,  0,  0,  1 ]   Previous result shifted 4 cells ( 2** 2 )
\    --------------------------------------------
\    Sum   [ 1,  2,  1,  0,  2,  2,  0,  0,  1 ]   Number of integers with ix as first iteration sum of digits sq

CELL 8 * 301 * 1000 /   CONSTANT max-digits   \  301 1000 /  is log10( 2 )
\ 19 for a 64 bit Forth and 9 for a 32 bit one.

\ **********************************
\ ****  Create a counted array  ****
\ **********************************

: counted-array  \ create: #elements -- ;  does> -- a ;
  CREATE
    HERE SWAP 1+ CELLS DUP ALLOT ERASE
  DOES> ;

\ ***********************************
\ **** Array manipulation words. ****
\ ***********************************

: arr-copy  \ a-src a-dest -- ;  \ Copy array array at a-src to array at a-dest
  OVER @ 1+ CELLS CMOVE ;

: arr-count  \ a -- a' ct ;
\ Fetch the count of cells in the array and shift addr to point to element 0.
  DUP CELL+ SWAP @ ;

: th-element  \ a ix -- a' ;  \ Leave address of the ix th element of array at a on the stack
  1+ CELLS + ;

: arr-empty   \ a -- ;  \ Sets all array elements to zero and zero length
  dup @ 1+ CELLS ERASE ;

: arr+   \ a-src a-dest count -- ;
  \ Add each cell from a-src to the cells from a-dest for count elements
  \ Storing the result in a-dest
  CELLS 0 DO
    OVER I + @ OVER I + +!   \ I is a byte count offset into either array
  CELL +LOOP
  2DROP ;  \ DROP the two base addresses

: arr.   \ a -- ;   \ Print the array. Used to debug.
  ." [ "  arr-count CELLS BOUNDS ?DO   i @ .   CELL +LOOP ." ]"   ;

\ ***********************************
\ ****  Sum digit squared words  ****
\ ***********************************

: sum-digit-sq   \ n -- n' ;
  0 SWAP
  BEGIN   DUP   WHILE
    10 /MOD  >R DUP * + R>
  REPEAT DROP ;

: 89or1<>    \ n -- f ;  \ True if n not equal to 89 or 1.
  DUP 89 <> AND 1 > ;

: iterated-89=   \ n -- f ;   \ True if n iterates to 89, false once it iterates to 1 ( or 0 ).
  BEGIN   DUP 89or1<>   WHILE
    sum-digit-sq
  REPEAT 89 = ;

\ *****************************************************
\ **** Create `count-sumsq` and `sumsq-old` arrays ****
\ *****************************************************

max-digits 81 * 1+    counted-array count-sumsq
max-digits 1- 81 * 1+ counted-array sumsq-old

: init-count-sumsq  \ -- ; \ Initialise the count-sumsq to [ 1 ]
  count-sumsq arr-empty             \ Ensure all zero
  1 count-sumsq !                   \ Set the length of the count-sumsq to 1 cell.
  1 count-sumsq  0 th-element ! ;   \ Store 1 in the first element.

: set-count-sumsq  \ #digits -- ;    \ The main work.  Only called with valid #digits
  init-count-sumsq
  0 ?DO
    count-sumsq sumsq-old arr-copy   \ copy count-sumsq to sumsq-old
    81 count-sumsq +!              \ Extend count-sumsq by 81 (9*9) cells
    10 1 DO
      sumsq-old arr-count                    ( a-sumsq-old' len )
      count-sumsq I DUP * th-element SWAP arr+
    LOOP
  LOOP ;

: count-89s   \ #digits -- n ;
  DUP max-digits U> IF
    ." Number of digits must be between 0 and " max-digits .
    DROP 0
  ELSE
    set-count-sumsq
    0 count-sumsq @ 0 DO
      count-sumsq I th-element @      ( cum ith-count )
      I iterated-89=              \ True if the index delivers 89.
      AND +     \ True is -1 ( all bits set ) AND with the count and add to the cum.
    LOOP
  THEN ;

: test    \ #digits :
  CR max-digits min 1+ 1 ?DO
    I 5 .r 2 SPACES I count-89s . CR
  LOOP ;
