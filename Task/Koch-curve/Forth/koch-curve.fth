include lib/graphics.4th
include lib/math.4th
include lib/enter.4th

: (p3&p5) 2* + 3 / ;                   ( n1 n2 -- n2+n2+n1/3)
: (p3) rot (p3&p5) >r swap (p3&p5) r> ;
: (p5) rot swap (p3&p5) >r (p3&p5) r> ;
: (*/10K) * 10K 2 / + 10K / ;          ( n1 n2 -- n1*n2/10000)

: koch                                 ( x1 y1 x2 y2 n --)
  dup 0> if
    1- >r 2over 2over (p5)
    2>r 2over 2over (p3) 2r>           ( x1 y1 x2 y2 x3 y3 x5 y5 )
    PI*10K 3 / >r 2over 2over rot - >r swap - >r ( R: n theta y5-y3 x5-x3)
    2over r@ r"@ (sin) (*/10K) - r'@ r"@ (cos) (*/10K) +
    swap  r@ r"@ (cos) (*/10K) + r'@ r"@ (sin) (*/10K) +
    rdrop rdrop rdrop swap             ( x1 y1 x2 y2 x3 y3 x5 y5 x4 y4 R: n)

    2rot 2>r 2>r 2rot 2r> 2r> 2rot     ( x2 y2 x5 y5 x4 y4 x3 y3 x1 y1 R: n)
    2over r@ recurse                   ( x2 y2 x5 y5 x4 y4 x3 y3 R: n )
    2over r@ recurse                   ( x2 y2 x5 y5 x4 y4 R: n )
    2over r@ recurse                   ( x2 y2 x5 y5 R: n)
    2swap r> recurse                   ( --)
  ;then drop line
;

600 pic_width ! 600 pic_height !       \ set canvas size
color_image 255 whiteout blue          \ paint blue on white

." Level (0-4): " enter 0 max 4 min >r

450 100 450 500 r@ koch                \ paint the snowflake
115 300 450 100 r@ koch
450 500 115 300 r> koch

s" gkoch.ppm" save_image               \ save the image
