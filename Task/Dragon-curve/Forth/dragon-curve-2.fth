include lib/graphics.4th
include lib/gturtle.4th

2 constant dragon-step

: dragon ( depth dir -- )
  over 0= if dragon-step forward 2drop exit then
  dup right
  over 1-  45 recurse
  dup 2* left
  over 1- -45 recurse
  right drop ;

150 pic_width !
210 pic_height !
color_image

clear-screen 50 95 turtle!
xpendown 13 45 dragon
s" 4tHdragon.ppm" save_image
