USING: assocs formatting fry kernel math math.functions
math.parser math.ranges math.statistics sequences ;
IN: rosetta-code.A260182

: pandigital? ( n base -- ? )
    [ >base histogram assoc-size ] keep >= ;

! Return the smallest decimal integer square root whose squared
! digit length in base n is at least n.
: search-start ( base -- n ) dup 1 - ^ sqrt ceiling >integer ;

: find-root ( base -- n )
    [ search-start ] [ ] bi
    '[ dup sq _ pandigital? ] [ 1 + ] until ;

: show-base ( base -- )
    dup find-root dup sq pick [ >base ] curry bi@
    "Base %2d: %8s squared = %s\n" printf ;

: main ( -- ) 2 16 [a,b] [ show-base ] each ;

MAIN: main
