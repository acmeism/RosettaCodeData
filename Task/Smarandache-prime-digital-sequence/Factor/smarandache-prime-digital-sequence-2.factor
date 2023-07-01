USING: combinators generalizations io kernel math math.functions
math.primes prettyprint sequences ;
IN: rosetta-code.smarandache

! Observations:
! * For 2-digit numbers and higher, only 3 and 7 are viable in
!   the ones place.
! * Only 2, 3, 5, and 7 are viable anywhere else.
! * It is possible to use this information to drastically
!   reduce the amount of numbers to check for primality.
! * For instance, by these rules we can tell that the next
!   potential Smarandache prime digital after 777 is 2223.

: next-one ( n -- n' ) 3 = 7 3 ? ; inline

: next-ten ( n -- n' )
    { { 2 [ 3 ] } { 3 [ 5 ] } { 5 [ 7 ] } [ drop 2 ] } case ;

: inc ( seq quot: ( n -- n' ) -- seq' )
    [ 0 ] 2dip [ change-nth ] curry keep ; inline

: inc1  ( seq -- seq' ) [ next-one ] inc ;
: inc10 ( seq -- seq' ) [ next-ten ] inc ;

: inc-all ( seq -- seq' )
    inc1 [ zero? not [ next-ten ] when ] V{ } map-index-as ;

: carry ( seq -- seq' )
    dup [ 7 = not ] find drop {
        { 0 [ inc1 ] }
        { f [ inc-all 2 suffix! ] }
        [ cut [ inc-all ] [ inc10 ] bi* append! ]
    } case ;

: digits>integer ( seq -- n ) [ 10 swap ^ * ] map-index sum ;

: next-smarandache ( seq -- seq' )
    [ digits>integer prime? ] [ carry dup ] do until ;

: .sm ( seq -- ) <reversed> [ pprint ] each nl ;

: first25 ( -- )
    2 3 5 7 [ . ] 4 napply V{ 7 } clone
    21 [ next-smarandache dup .sm ] times drop ;

: nth-smarandache ( n -- )
    4 - V{ 7 } clone swap [ next-smarandache ] times .sm ;

: smarandache-demo ( -- )
    "First 25 members of the Smarandache prime-digital sequence:"
    print first25 nl { 100 1000 10000 100000 } [
        dup pprint "th member: " write nth-smarandache
    ] each ;

MAIN: smarandache-demo
