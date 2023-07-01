USING: kernel math sequences ;

: longmult-seq ( xs ys -- zs )
[ * ] cartesian-map
dup length iota [ 0 <repetition> ] map
[ prepend ] 2map
[ ] [ [ 0 suffix ] dip [ + ] 2map ] map-reduce ;

: integer->digits ( x -- xs )  { } swap  [ dup 0 > ] [ 10 /mod swap [ prefix ] dip ] while  drop ;
: digits->integer ( xs -- x )  0 [ swap 10 * + ] reduce ;

: longmult ( x y -- z )  [ integer->digits ] bi@ longmult-seq digits->integer ;
