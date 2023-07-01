create M 32 cells allot

: enter refill drop parse-word evaluate ; : M[] cells M + ;
: init M 32 cells bounds ?do i ! 1 cells +loop ;
: b-a+! dup dup cell+ @ M[] swap @ M[] @ negate over +! ;
: c b-a+! @ 1- 0< if 2 cells + @ else swap 3 + then nip ;
: b? dup cell+ @ 0< if @ M[] @ emit 3 + else c then ;
: a? dup @ 0< if cell+ @ M[] enter swap ! 3 + else b? then ;
: subleq cr 0 begin dup 1+ 0> while dup M[] a? repeat drop ;

0 10 33 100 108 114 111 119 32 44 111 108 108 101 72
-1 0 0 15 15 -1 3 16 -1 1 16 -1 -1 17 -1 17 15

init subleq
