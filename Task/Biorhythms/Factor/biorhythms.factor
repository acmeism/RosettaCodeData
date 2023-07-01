USING: calendar calendar.parser formatting io kernel math
math.constants math.functions ;

: days-between ( ymd-str ymd-str -- n )
    [ ymd>timestamp ] bi@ time- duration>days abs ;

: trend ( pos len -- str ) / 4 * floor 3 divisor? "↑" "↓" ? ;

: percent ( pos len -- x ) [ 2pi * ] [ / sin 100 * ] bi* ;

: .day ( days cycle-length day-type -- )
    write [ mod ] keep [ drop ] [ percent ] [ trend ] 2tri
    " day %d: %.1f%%%s\n" printf ;

: .biorhythm ( ymd-str ymd-str -- )
    2dup "Born %s, Target %s\n" printf days-between dup
    "Day %d\n" printf
    [ 23 "Physical" .day ]
    [ 28 "Emotional" .day ]
    [ 33 "Mental" .day ] tri ;

"1809-02-12" "1863-11-19" .biorhythm
