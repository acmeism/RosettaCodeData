create romans 0 , 1 , 5 , 21 , 9 , 2 , 6 , 22 , 86 , 13 ,
  does> swap cells + @ ;

: roman-digit                          ( a1 n1 a2 n2 -- a3)
  drop >r romans
  begin dup while tuck 4 mod 1- chars r@ + c@ over c! char+ swap 4 / repeat
  r> drop drop
;

: (split) swap >r /mod r> swap ;

: >roman                               ( n1 a -- a n2)
  tuck 1000 (split) s" M  " roman-digit 100 (split) s" CDM" roman-digit
  10 (split) s" XLC" roman-digit 1 (split) s" IVX" roman-digit nip over -
;

create (roman) 16 chars allot

1999 (roman) >roman type cr
