USING: accessors calendar calendar.english formatting
generalizations kernel math math.order math.vectors sequences ;

: check-year ( year -- )  ! months and days checked by <date>
    1582 9999 between?
    [ "Year must be between 1582 and 9999." throw ] unless ;

: doomsday ( year -- n )
    { 4 100 400 } [ mod ] with map { 5 4 6 } vdot 2 + 7 mod ;

: anchorday ( year month -- m )
    1 - swap leap-year? { 4 1 } { 3 7 } ?
    { 7 4 2 6 4 1 5 3 7 5 } append nth ;

: weekday ( date -- str )
    [ year>> dup check-year doomsday ] [ day>> + ]
    [ dup year>> swap month>> anchorday - 7 + 7 mod ] tri
    day-names nth ;

: test ( date -- )
    [ "%B %d, %Y" strftime ]
    [ now before? "was" "will be" ? ]
    [ weekday ] tri
    "%s %s on a %s.\n" printf ;

1800 1 6
1875 3 29
1915 12 7
1970 12 23
2043 5 14
2077 2 12
2101 4 2
[ <date> test ] 3 7 mnapply
