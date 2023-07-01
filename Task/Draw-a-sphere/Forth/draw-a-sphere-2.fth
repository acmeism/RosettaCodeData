: 3dup 2 pick 2 pick 2 pick ;

: sqrt ( u -- sqrt )            ( Babylonian method                 )
  dup 2/                        ( first square root guess is half   )
  dup 0= if drop exit then      ( sqrt[0]=0, sqrt[1]=1              )
  begin dup >r 2dup / r> + 2/   ( stack: square old-guess new-guess )
  2dup > while                  ( as long as guess is decreasing    )
  nip repeat                    ( forget old-guess and repeat       )
  drop nip ;

: normalize ( x1 y1 z1 -- x1' y1' z1' )    ( normalise down to 1000 )
  3dup dup * rot dup * rot dup * + + sqrt 1000 / >r        ( length )
  r@ / rot r@ / rot r> / rot ;

: r2-y2-x2 ( x y r -- z2 ) dup * swap dup * - swap dup * - ;

0 value fileidstore
: image-open ( r -- )
  outfile-id to fileidstore
  s" sphere.pgm" w/o create-file throw to outfile-id
  s\" P2\n" type 2* dup . .
  s\" \n255" type ;
: image-close outfile-id close-file throw fileidstore to outfile-id ;

: map-to-shade   255 * 1000 /    1 max    255 min ;

: dot-light ( x y z -- i )      ( hard coded light vector z, y, x   )
  -770 *    rot 461 *    rot 461 *    + +
  0 min 1000 / ;

: intensity ( x y z -- u )  dot-light dup * 1000 /   map-to-shade ;

: pixel ( x y r -- c )
  3dup r2-y2-x2 dup 0> if                              ( if in disk )
    sqrt nip    normalize intensity              ( z=sqrt[r2-x2-y2] )
  else 2drop 2drop 255                                 ( else blank )
  then ;

: draw ( r -- )    ( r x1000 )
dup image-open
1000 * dup dup negate do
   cr
   dup dup negate do
      dup I 500 + J 500 + rot pixel .
   1000 +loop
1000 +loop drop image-close ;

200 draw
