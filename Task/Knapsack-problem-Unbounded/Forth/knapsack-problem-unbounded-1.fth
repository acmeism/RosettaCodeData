\ : value ; immediate
: weight cell+ ;
: volume 2 cells + ;
: number 3 cells + ;

\      item value weight volume number
create panacea 30 ,   3 ,  25 , 0 ,
create ichor   18 ,   2 ,  15 , 0 ,
create gold    25 ,  20 ,   2 , 0 ,
create sack     0 , 250 , 250 ,

: fits? ( item -- ? )
  dup weight @ sack weight @ > if drop false exit then
      volume @ sack volume @ > 0= ;

: add ( item -- )
  dup        @        sack        +!
  dup weight @ negate sack weight +!
  dup volume @ negate sack volume +!
  1 swap number +! ;

: take ( item -- )
  dup        @ negate sack        +!
  dup weight @        sack weight +!
  dup volume @        sack volume +!
  -1 swap number +! ;

variable max-value
variable max-pan
variable max-ich
variable max-au

: .solution
  cr
  max-pan @ . ." Panaceas, "
  max-ich @ . ." Ichors, and "
  max-au  @ . ." Gold for a total value of "
  max-value @ 100 * . ;

: check
  sack @ max-value @ <= if exit then
  sack           @ max-value !
  panacea number @ max-pan   !
  ichor   number @ max-ich   !
  gold    number @ max-au    !
  ( .solution ) ;    \ and change <= to < to see all solutions

: solve-gold
  gold fits? if gold add  recurse  gold take
  else check then ;

: solve-ichor
  ichor fits? if ichor add  recurse  ichor take then
  solve-gold ;

: solve-panacea
  panacea fits? if panacea add  recurse  panacea take then
  solve-ichor ;

solve-panacea .solution
