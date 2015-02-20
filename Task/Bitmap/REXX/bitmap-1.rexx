/*REXX pgm demonstrates how to handle a simple RGB raster graphics image*/
red    = '00000000 00000000 11111111'b /*define a    red    value.      */
blue   = '11111111 00000000 00000000'b /*define a    blue   value.      */
blue   = 'ff 00 00'x                   /*another way to define   blue.  */
image.=                                /*"allocate" an "array" to nulls.*/
call RGBfill red                       /*set the entire image to red.   */
call RGBset  10,40,blue                /*set  a  pixel        to blue.  */

x=10;  y=40;  pix=RGBget(x,y)          /*get the color of a pixel.      */
hexv = c2x(pix)                        /*get hex    value of pix's color*/
binv = x2b(hexv)                       /* "  binary   "    "  "      "  */

say  'pixel'   x","y   '='   binv      /*show the binary value of 20,50 */
bin3v = left(binv,8)  substr(binv,9,8) right(binv,8)
say  'pixel'   x","y   '='   bin3v     /*show again, but with spaces.   */
say                                    /*show a blank between bin & hex.*/
say  'pixel'   x","y   '='   hexv      /*show again, but in hexadecimal.*/
hex3v = left(hexv,2)  substr(hexv,3,2) right(hexv,2)
say  'pixel'   x","y   '='   hex3v     /*show again, but with spaces.   */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────RGBFILL subroutine──────────────────*/
RGBfill: procedure expose image.;      image.=arg(1);   return
/*──────────────────────────────────RGBGET subroutine───────────────────*/
RGBget: procedure expose image.;       parse arg Xpixel,Ypixel
return  image.Xpixel.Ypixel            /*get & return the pixel's color.*/
/*──────────────────────────────────RGBRASTER subroutine────────────────*/
RGBraster: procedure expose image.;    parse arg Xsize,Ysize,color;   RGB=
             do    x=1  to Xsize;  _=  /*build raster 1 line at a time. */
                do y=1  to Ysize       /*  "   a line " pixel " "   "   */
                _=_ || image.x.y       /*append single pixel to the line*/
                end   /*y*/            /* [↑]  all done building a line.*/
             RGB=RGB || _              /*append a single line to raster.*/
             end      /*x*/            /* [↑]  all done building raster.*/
return RGB                             /*return RGB raster to invoker.  */
/*──────────────────────────────────RGBSET subroutine───────────────────*/
RGBset: procedure expose image.;       parse arg Xpixel,Ypixel,color
image.Xpixel.Ypixel=color;    return   /*define pixel, return to invoker*/
