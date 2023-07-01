USING: combinators interpolate io kernel prettyprint math
math.functions math.order pair-rocket ;
IN: rosetta-code.square-but-not-cube

: fn ( s c n -- s' c' n' )
    dup 31 < [
        2over [ sq ] [ 3 ^ ] bi* <=> {
            +lt+ => [ [ dup sq . 1 + ] 2dip 1 + fn ]
            +eq+ => [ [ dup sq [I ${} cube and squareI] nl 1 + ] [ 1 + ] [ ] tri* fn ]
            +gt+ => [ [ 1 + ] dip fn ]
        } case
    ] when ;

1 1 1 fn 3drop
