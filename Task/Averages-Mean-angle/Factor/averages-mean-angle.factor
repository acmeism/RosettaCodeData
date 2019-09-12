USING: formatting kernel math math.functions math.libm math.trig
sequences ;

: mean-angle ( seq -- x )
    [ deg>rad ] map [ [ sin ] map-sum ] [ [ cos ] map-sum ]
    [ length ] tri recip [ * ] curry bi@ fatan2 rad>deg ;

: show ( seq -- )
    dup mean-angle "The mean angle of %u is: %f°\n" printf ;

{ { 350 10 } { 90 180 270 360 } { 10 20 30 } } [ show ] each
