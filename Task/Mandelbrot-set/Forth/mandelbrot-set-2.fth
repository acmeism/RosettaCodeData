include lib/graphics.4th               \ graphics support is needed

640 pic_width !                        \ width of the image
480 pic_height !                       \ height of the image

create shade                           \ map the shades of the image
  ' black ,                            \ this is the colorscheme
  ' blue ,
  ' cyan ,
  ' green ,
  ' yellow ,
  ' red ,
  ' magenta ,
  ' blue ,
  ' cyan ,
  ' green ,
  ' yellow ,
  ' white ,
does> swap cells + @c execute ;        \ loop through the shades available

color_image                            \ we're making a color image

15121 -15120 do                        \ do y-coordinate
  15481 -21000 do                      \ do x-coordinate
    j 0 0 0                            ( l u v i)
    200 0 do                           \ get color
      >r
      over dup 10 / * 1000 /           \ calculate X and Y
      over dup 10 / * 1000 /           \ if X+Y > 40000
      over over + r> swap 40000 >      \ use the color in the loop
      if
        drop drop drop i 11 min leave
      else                             \ otherwise try the next one
        j swap >r - - >r * 5000 / over + r> swap r>
      then
    loop                               \ drop all parameters and set the shade
    shade drop drop drop               \ now set the proper pixel
    j 15120 + 63 / i 21000 + 57 / set_pixel
  57 +loop                             \ we're scaling the x-coordinate
63 +loop                               \ we're scaling the y-coordinate

s" mandelbt.ppm" save_image            \ done, save the image
dup gshow
free bye
