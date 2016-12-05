USING: bit-arrays formatting fry kernel math math.ranges
sequences ;
IN: rosetta.doors

CONSTANT: number-of-doors 100

: multiples ( n -- range )
    0 number-of-doors rot <range> ;

: toggle-multiples ( n doors -- )
    [ multiples ] dip '[ _ [ not ] change-nth ] each ;

: toggle-all-multiples ( doors -- )
    [ number-of-doors [1,b] ] dip '[ _ toggle-multiples ] each ;

: print-doors ( doors -- )
    [
        swap "open" "closed" ? "Door %d is %s\n" printf
    ] each-index ;

: main ( -- )
    number-of-doors 1 + <bit-array>
    [ toggle-all-multiples ] [ print-doors ] bi ;

main
