USING: continuations formatting io kernel math.ranges
prettyprint sequences ;

: try-range ( from length step -- )
    [ <range> { } like . ]
    [ 4drop "Exception: divide by zero." print ] recover ;

{
    { -2 2 1 } { 2 2 0 } { -2 2 -1 } { -2 2 10 } { 2 -2 1 }
    { 2 2 1 } { 2 2 -1 } { 2 2 0 } { 0 0 0 }
}
[
    first3
    [ "%2d %2d %2d <range>  =>  " printf ]
    [ try-range ] 3bi
] each
