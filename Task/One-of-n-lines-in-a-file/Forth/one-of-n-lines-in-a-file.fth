require random.fs

: frnd
   rnd 0 d>f [ s" MAX-U" environment? drop 0 d>f 1/f ] fliteral f* ;
: u>f 0 d>f ;
: one_of_n ( u1 -- u2 )
   1 swap  1+ 2 ?do  frnd  i u>f 1/f  f<  if drop i then  loop ;

create hist 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,  does> swap cells + ;
: simulate  1000000 0 do  1  10 one_of_n 1- hist  +!  loop ;
: .hist  cr 10 0 do  i 1+ 2 .r ." : "  i hist @ .  cr loop ;

simulate .hist bye
