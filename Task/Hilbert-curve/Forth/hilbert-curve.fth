include lib/graphics.4th

64 constant /width                     \ hilbert curve order^2
 9 constant /length                    \ length of a line

variable origin                        \ point of origin

aka r@  lg                             \ get parameters from return stack
aka r'@ i1                             \ so define some aliases
aka r"@ i2                             \ to make it a bit more readable

: origin! 65536 * + origin ! ;         ( n1 n2 --)
: origin@ origin @ 65536 /mod ;        ( -- n1 n2)

: hilbert                              ( x y lg i1 i2 --)
  >r >r >r lg 1 = if                   \ if lg equals 1
    rdrop rdrop rdrop origin@ 2swap    \ get point of origin
    /width swap - /length * >r /width swap - /length * r>
    2dup origin! line                  \ save origin and draw line
  ;then

  r> 2/ >r                             \ divide lg by 2
  over over i1 lg * tuck + >r + r> lg i1 1 i2 - hilbert
  over over 1 i2 - lg * + swap i2 lg * + swap lg i1 i2 hilbert
  over over 1 i1 - lg * tuck + >r + r> lg i1 i2 hilbert
  i2 lg * + swap 1 i2 - lg * + swap r> 1 r> - r> hilbert
;

585 pic_width ! 585 pic_height !       \ set canvas size
color_image 255 whiteout blue          \ paint blue on white
0 dup origin!                          \ set point of origin
0 dup /width over dup hilbert          \ hilbert curve, order=8
s" ghilbert.ppm" save_image            \ save the image
