USING: formatting kernel math math.parser sequences ;

: nth-fairshare ( n base -- m )
    [ >base string>digits sum ] [ mod ] bi ;

: <fairshare> ( n base -- seq )
    [ nth-fairshare ] curry { } map-integers ;

{ 2 3 5 11 }
[ 25 over <fairshare> "%2d -> %u\n" printf ] each
