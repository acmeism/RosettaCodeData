USING: combinators fry kernel locals math prettyprint sequences ;
IN: rosetta-code.two-sum

:: two-sum ( seq target -- index-pair )
    0 seq length 1 - :> ( x! y! ) [
        x y [ seq nth ] bi@ + :> sum {
            { [ sum target = x y = or ] [ f ] }
            { [ sum target > ] [ y 1 - y! t ] }
            [ x 1 + x! t ]
        } cond
    ] loop
    x y = { } { x y } ? ;

{ 21 55 11 } [ '[ { 0 2 11 19 90 } _ two-sum . ] call ] each
