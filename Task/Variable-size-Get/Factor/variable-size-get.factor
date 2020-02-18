USING: layouts memory prettyprint ;

! Show size in bytes
{ 1 2 3 } size .   ! 48
1231298302914891021239102 size .   ! 48

! Doesn't work on fixnums and other immediate objects
10 size .   ! 0

! Show number of bits in a fixnum
fixnum-bits .   ! 60
