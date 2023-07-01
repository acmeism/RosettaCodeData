\ Values used to avoid locals or some confusing stack juggling.
\ They could be replaced by locals if preferred.
0 VALUE addr
0 VALUE ndims
: darray    \ Create: d(n-1) .. d0 size n "<name-of-array>" --  ;
            \ Does:  ix[n-1] .. ix0 -- addr
            \ Creates an n dimensional array with axes dn-1 .. d0

  \ d(n-i)  .. d0 - the length of the n dimensions.
  \ size          - The size in bytes of the basic elenment in the array.
  \               - e.g 1 for chars, 2 for 16 bit etc..
  \ n - The number of dimensions

  \ Term stride is taken from numpy.  It's the gap between consqutive indices
  \ in a given dimension.  ix * stride gives an offset from a base address.

  \ CELLS           0               1         2    ...     n+1   n+2 ->
  \    Stride[0] addr  Stride[n] addr  stride[0]    stride[n-1]  data ->
  \           CELL[2]       CELL[n+2]       size
  \ Storing the stride addresses at CELLS 0 and 1 gives fast access for
  \ the do loop in the DOES> section to loop through the strides.

  CREATE
    IS ndims   HERE IS addr        \ n to ndims, HERE to addr
    0 , 0 ,                        \ Placeholders for loop-bounds
    DUP ,                          \ size stored at CELL[2]
    ndims 1- 0 ?DO   * DUP , LOOP  \ Calculate and store strides 1 to n-1.
    HERE addr CELL + !             \ Store high address for strides
    * ALLOT                        \ Calculate and allocate the space
    addr 2 CELLS + addr !          \ Calculate & store low addr for strides

  DOES>     \ ix[n-1] .. ix[0] -- addr ;
    2@ OVER SWAP   ( data-addr stride-addr[n] stride-addr[0] )
    ?DO
      SWAP i @ * +    \ multiply strides by indices and add to base address
    CELL +LOOP ;

  2 3 4 5 CELL 4 darray test4d \ 4d array of integers
\ 2 3 4 5   20 4 darray 20byte-records-4D

\ Word to fill the array
: test4d-fill
  2 0 DO i
    3 0 DO i
      4 0 DO
        5 0 DO
          2DUP 100 * SWAP 1000 * +
          j 10 * + i +
          2 PICK 2 PICK j i test4d !
        LOOP
      LOOP
    DROP LOOP
  DROP LOOP ;

: [.  ." [ " ;
: ].  ." ] " ;

defer p-array
: print-4d    \ <array-name> -- ; Prints 4d array
  ' IS p-array
  2 0 DO i CR [.
    3 0 DO i CR 2 SPACES [.
      4 0 DO
        CR 4 SPACES [.
        5 0 DO
          2DUP j i p-array @ 8 .r
        LOOP ].
      LOOP ].
    DROP LOOP ].
  DROP LOOP ;

test4d-fill

print-4d test4d
