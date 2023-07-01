USING: formatting kernel math math.extras math.ranges sequences ;

: bell ( m -- n )
    [ 1 ] [ dup [1,b] [ stirling ] with map-sum ] if-zero ;

50 [ bell ] { } map-integers [ 15 head ] [ last ] bi
"First 15 Bell numbers:\n%[%d, %]\n\n50th: %d\n" printf
