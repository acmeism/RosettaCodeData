USING: combinators kernel make math locals prettyprint sequences ;
IN: rosetta-code.quickselect

:: quickselect ( k seq -- n )
    seq unclip :> ( xs x )
    xs [ x < ] partition :> ( ys zs )
    ys length :> l
    {
        { [ k l < ] [ k ys quickselect ] }
        { [ k l > ] [ k l - 1 - zs quickselect ] }
        [ x ]
    } cond ;

: quickselect-demo ( -- )
    { 9 8 7 6 5 0 1 2 3 4 } dup length <iota> swap
    [ [ quickselect , ] curry each ] { } make . ;

MAIN: quickselect-demo
