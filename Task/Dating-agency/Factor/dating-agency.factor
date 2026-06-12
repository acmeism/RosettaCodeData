USING: formatting io kernel math math.primes math.vectors
prettyprint qw sequences sets ;

CONSTANT: ladies qw{
    Abigail Emily Haley Leah Maru
    Penny Caroline Jodi Marnie Robin
}

CONSTANT: sailor "Willy"

: prime-root? ( n -- ? ) 1 - 9 mod 1 + prime? ;                    ! is the digital root prime?
: nice? ( lady sailor -- ? ) [ hashcode ] bi@ + prime-root? ;      ! a lady is nice if the sum of the hashcode of her name and the sailor's name has a prime digit root
: lovable? ( lady sailor -- ? ) vdot prime-root? ;                 ! a lady is lovable if the dot product of her name and the sailor's name has a prime digital root

: nice ( -- seq ) ladies [ sailor nice? ] filter ;
: lovable ( -- seq ) ladies [ sailor lovable? ] filter ;
: compatible ( -- seq ) nice lovable intersect ;
: ladies. ( seq -- ) ", " join print ;

"lady       nice?      lovable?" print
"------------------------------" print
ladies [
    dup sailor [ nice? ] [ lovable? ] bi-curry bi
    [ "yes" "no" ? ] bi@
    "%-10s %-10s %-10s\n" printf
] each nl

"Based on this analysis:" print nl
"The dating agency should suggest the following dates:" print
nice ladies. nl
sailor "And %s should offer to date these ones:\n" printf
lovable ladies. nl
sailor "But just between us, only the following ladies are compatible with %s:\n" printf
compatible ladies.
