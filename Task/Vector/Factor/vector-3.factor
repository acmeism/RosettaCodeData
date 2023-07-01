USING: kernel formatting prettyprint rosetta-code.vector
sequences ;
IN: rosetta-code.vector

: demo ( a b quot -- )
    3dup [ unparse ] tri@ rest but-last
    "%16s %16s%3s= " printf call . ; inline

VEC{ -8.4 1.35 } VEC{ 10 11/123 } [ v+ ] demo
VEC{ 5 3 } VEC{ 4 2 } [ v- ] demo
VEC{ 4 -8 } 2 [ v* ] demo
VEC{ 5 7 } 2 [ v/ ] demo

! You can still make a vector without the literal syntax of
! course.

5 2 <vec> 1.3 [ v* ] demo
