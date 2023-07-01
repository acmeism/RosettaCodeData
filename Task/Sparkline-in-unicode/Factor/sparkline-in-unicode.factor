USING: formatting kernel math math.order math.parser
math.statistics sequences splitting ;

: sparkline-index ( v min max -- i )
    [ drop - 8 * ] [ swap - /i ] 2bi 0 7 clamp 9601 + ;

: (sparkline) ( seq -- new-seq )
    dup minmax [ sparkline-index ] 2curry "" map-as ;

: sparkline ( str -- new-str )
    ", " split harvest [ string>number ] map (sparkline) ;

{
    "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1"
    "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"
    "0, 1, 19, 20"
    "0, 999, 4000, 4999, 7000, 7999"
} [ dup sparkline "%u -> %s\n" printf ] each
