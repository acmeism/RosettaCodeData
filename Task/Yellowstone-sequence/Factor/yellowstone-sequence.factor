USING: accessors assocs colors.constants
combinators.short-circuit io kernel math prettyprint sequences
sets ui ui.gadgets ui.gadgets.charts ui.gadgets.charts.lines ;

: yellowstone? ( n hs seq -- ? )
    {
        [ drop in? not ]
        [ nip last gcd nip 1 = ]
        [ nip dup length 2 - swap nth gcd nip 1 > ]
    } 3&& ;

: next-yellowstone ( hs seq -- n )
    [ 4 ] 2dip [ 3dup yellowstone? ] [ [ 1 + ] 2dip ] until
    2drop ;

: next ( hs seq -- hs' seq' )
    2dup next-yellowstone [ suffix! ] [ pick adjoin ] bi ;

: <yellowstone> ( n -- seq )
    [ HS{ 1 2 3 } clone dup V{ } set-like ] dip dup 3 <=
    [ head nip ] [ 3 - [ next ] times nip ] if ;


! Show first 30 Yellowstone numbers.

"First 30 Yellowstone numbers:" print
30 <yellowstone> [ pprint bl ] each nl

! Plot first 100 Yellowstone numbers.

chart new { { 0 100 } { 0 175 } } >>axes
line new COLOR: blue >>color
100 <iota> 100 <yellowstone> zip >>data
add-gadget "Yellowstone numbers" open-window
