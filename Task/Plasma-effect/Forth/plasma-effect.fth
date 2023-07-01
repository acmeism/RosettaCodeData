: sqrt ( u -- sqrt )            ( Babylonian method                 )
  dup 2/                        ( first square root guess is half   )
  dup 0= if drop exit then      ( sqrt[0]=0, sqrt[1]=1              )
  begin dup >r 2dup / r> + 2/   ( stack: square old-guess new-guess )
  2dup > while                  ( as long as guess is decreasing    )
  nip repeat                    ( forget old-guess and repeat       )
  drop nip ;

: sgn 0< if -1 else 1 then ;
: isin
  256 mod 128 -                 \ full circle is 255 "degrees"
  dup dup sgn * 128 swap - *    \ second order approximation
  negate 32 / ;                 \ amplitude is +/-128

: color-shape 256 mod 6 * 765 - abs 256 - 0 max 255 min ;  \ trapezes
: hue
  dup color-shape .          \ red
  dup 170 + color-shape .    \ green
  85 + color-shape . ;       \ blue

: plasma
  outfile-id >r
  s" plasma.ppm" w/o create-file throw to outfile-id
  s\" P3\n500 500\n255\n" type
  500 0 do
    500 0 do
      i 2 * isin 128 +
      j 4 * isin 128 + +
      i j + isin 2 * 128 + +
      i i * j j * + sqrt 4 * isin 128 + +
      4 /
      hue
      s\" \n" type
    loop
    s\" \n" type
  loop

  outfile-id close-file throw
  r> to outfile-id ;

plasma
