: array ( n -- ) ( i -- addr)
  create cells allot
  does> swap cells + ;

100 array sequence

: sequence. ( n -- ) cr 0 ?do i sequence @ . loop ;

: ?unused ( n -- t | n )
  100 0 ?do
    dup i sequence @ = if unloop exit then
  loop drop true ;

: sequence-next ( n -- a[n] )
  dup 0= if 0 0 sequence ! exit then     ( case a[0]=0   )
  dup dup 1- sequence @ swap -           ( a[n]=a[n-1]-n )
  dup dup 0> swap ?unused true = and if
    nip exit then drop
  dup 1- sequence @ swap + ;             ( a[n]=a[n-1]+n )

: sequence-gen ( n -- )
  0 ?do i sequence-next i sequence ! loop ;

: sequence-repeated
  100 0 ?do
    i 0 ?do
      i sequence @ j sequence @ = if
        cr ." first repeated : a[" i . ." ]=a[" j . ." ]=" i sequence @ .  unloop unloop exit then
    loop
  loop ;

100 sequence-gen
15 sequence.
sequence-repeated
