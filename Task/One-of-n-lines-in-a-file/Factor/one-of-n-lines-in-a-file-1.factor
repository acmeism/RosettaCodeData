! rosettacode/random-line/random-line.factor
USING: io kernel locals math random ;
IN: rosettacode.random-line

:: random-line ( -- line )
    readln :> choice! 1 :> count!
    [ readln dup ]
    [ count 1 + dup count! random zero?
        [ choice! ] [ drop ] if
    ] while drop
    choice ;
