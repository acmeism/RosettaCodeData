: array  create  dup ,  dup cells here swap 0 fill  cells allot ;
: [size] @ ;
: [cell] 1+ cells  + ;               \ hide offset=0 to index [0..n-1]

10 array MyArray

30 MyArray 7 [cell] !
MyArray 7 [cell] @ .                 \ 30

: 5fillMyArray  5  0 do  I  MyArray I [cell]  !  loop ;
: .MyArray      MyArray [size]  0 do  MyArray I [cell]  @ .  loop ;

.MyArray                             \ 0 0 0 0 0 0 30 0 0 0
5fillMyArray
.MyArray                             \ 1 2 3 4 5 0 30 0 0 0
