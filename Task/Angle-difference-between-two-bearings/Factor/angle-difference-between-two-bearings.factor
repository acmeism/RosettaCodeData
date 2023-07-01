USING: combinators generalizations kernel math prettyprint ;
IN: rosetta-code.bearings

: delta-bearing ( x y -- z )
    swap - 360 mod {
        { [ dup 180 > ] [ 360 - ] }
        { [ dup -180 < ] [ 360 + ] }
        [ ]
    } cond ;

: bearings-demo ( -- )
    20 45
    -45 45
    -85 90
    -95 90
    -45 125
    -45 145
    29.4803 -88.6381
    -78.3251 -159.036
    -70099.74233810938 29840.67437876723
    -165313.6666297357 33693.9894517456
    1174.8380510598456 -154146.66490124757
    60175.77306795546 42213.07192354373
    [ delta-bearing . ] 2 12 mnapply ;

MAIN: bearings-demo
