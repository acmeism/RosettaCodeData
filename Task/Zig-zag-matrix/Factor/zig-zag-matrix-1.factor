USING: columns fry kernel make math math.ranges prettyprint
sequences sequences.cords sequences.extras ;
IN: rosetta-code.zig-zag-matrix

: [1,b,1] ( n -- seq )
    [1,b] dup but-last-slice <reversed> cord-append ;

: <reversed-evens> ( seq -- seq' )
    [ even? [ <reversed> ] when ] map-index ;

: diagonals ( n -- seq )
    [ sq <iota> ] [ [1,b,1] ] bi
    [ [ cut [ , ] dip ] each ] { } make nip <reversed-evens> ;

: zig-zag-matrix ( n -- seq )
    [ diagonals ] [ dup ] bi '[
        [
            dup 0 <column> _ head ,
            [ _ < [ rest-slice ] when ] map-index harvest
        ] until-empty
    ] { } make ;

: zig-zag-demo ( -- ) 5 zig-zag-matrix simple-table. ;

MAIN: zig-zag-demo
