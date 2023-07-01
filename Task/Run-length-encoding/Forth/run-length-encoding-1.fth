variable a
: n>a  (.) tuck a @ swap move a +! ;
: >a   a @ c! 1 a +! ;
: encode ( c-addr +n a -- a n' )
  dup a ! -rot over c@ 1 2swap 1 /string bounds ?do
    over i c@ = if 1+
    else n>a >a i c@ 1 then
  loop n>a >a  a @ over - ;

: digit?  [char] 0 [ char 9 1+ literal ] within ;
: decode ( c-addr +n a -- a n' )
  dup a ! 0 2swap bounds ?do
    i c@ digit? if 10 * i c@ [char] 0 - + else
    a @ over i c@ fill a +! 0 then
  loop drop a @ over - ;
