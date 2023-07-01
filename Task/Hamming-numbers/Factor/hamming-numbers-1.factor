USING: accessors deques dlists fry kernel make math math.order
;
IN: rosetta.hamming

TUPLE: hamming-iterator 2s 3s 5s ;

: <hamming-iterator> ( -- hamming-iterator )
    hamming-iterator new
        1 1dlist >>2s
        1 1dlist >>3s
        1 1dlist >>5s ;

: enqueue ( n hamming-iterator -- )
    [ [ 2 * ] [ 2s>> ] bi* push-back ]
    [ [ 3 * ] [ 3s>> ] bi* push-back ]
    [ [ 5 * ] [ 5s>> ] bi* push-back ] 2tri ;

: next ( hamming-iterator -- n )
    dup [ 2s>> ] [ 3s>> ] [ 5s>> ] tri
    3dup [ peek-front ] tri@ min min
    [
        '[
            dup peek-front _ =
            [ pop-front* ] [ drop ] if
        ] tri@
    ] [ swap enqueue ] [ ] tri ;

: next-n ( hamming-iterator n -- seq )
    swap '[ _ [ _ next , ] times ] { } make ;

: nth-from-now ( hamming-iterator n -- m )
    1 - over '[ _ next drop ] times next ;
