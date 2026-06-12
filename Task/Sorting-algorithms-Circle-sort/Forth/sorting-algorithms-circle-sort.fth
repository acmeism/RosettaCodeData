[UNDEFINED] cell- [IF] : cell- 1 cells - ; [THEN]

defer precedes                         ( addr addr -- flag )
variable (sorted?)                     \ is the array sorted?

: (compare)                            ( a1 a2 -- a1 a2)
  over @ over @ precedes               \ flag if swapped
  if over over over @ over @ swap rot ! swap ! false (sorted?) ! then
;

: (circlesort)                         ( a1 a2 --)
  over over = if drop drop exit then   \ quit if indexes are equal
  over over swap                       \ swap indexes (end begin)
  begin
    over over >                        \ as long as middle isn't passed
  while
    (compare) swap cell- swap cell+    \ check and swap opposite elements
  repeat rot recurse recurse           \ split array and recurse
;

: sort                                 ( a n --)
  1- cells over +                      \ calculate addresses
  begin true (sorted?) ! over over (circlesort) (sorted?) @ until drop drop
;

:noname < ; is precedes

10 constant /sample
create sample 5 , -1 , 101 , -4 , 0 , 1 , 8 , 6 , 2 , 3 ,

: .sample sample /sample cells bounds do i ? 1 cells +loop ;

sample /sample sort .sample
