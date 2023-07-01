: array ( n -- )
  create
     dup ,                           \ remember size at offset 0
     dup cells here swap 0 fill      \ fill cells with zero
     cells allot                     \ allocate memory
  does> ( i addr -- )
     swap 1+ cells + ;               \ hide offset=0 to index [0..n-1]
: [size] -1 ;

10 array MyArray

30 7 MyArray !
7 MyArray @ .                        \ 30

: 5fillMyArray  5  0 do  I  I MyArray  !  loop ;
: .MyArray     [size] MyArray @  0 do  I MyArray  @ .  loop ;

.MyArray                             \ 0 0 0 0 0 0 30 0 0 0
5fillMyArray
.MyArray                             \ 1 2 3 4 5 0 30 0 0 0
