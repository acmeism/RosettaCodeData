USING: formatting generalizations geohash io kernel sequences ;

: encode-geohash ( latitude longitude precision -- str )
    [ >geohash ] [ head ] bi* ;

! Encoding
51.433718 -0.214126 2
51.433718 -0.214126 9
57.649110 10.407440 11
[
    3dup encode-geohash
    "geohash for [%f, %f], precision %2d = %s\n" printf
] 3 3 mnapply nl

! Decoding
"u4pruydqqvj" dup geohash>
"coordinates for %s ~= [%f, %f]\n" printf
