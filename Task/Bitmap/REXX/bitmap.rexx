/*REXX program shows how to handle a simple RGB raster graphics image.  */
image.='00 00 00'x                     /*set entire array to hex zeroes.*/

red='00000000 00000000 11111111'b      /*define a    red    value.      */
image.=red                             /*set the entire array to  red.  */

blue='11111111 00000000 00000000'b     /*define a    blue   value.      */
blue='ff 00 00'x                       /*another way to define   blue.  */
image.10.40=blue                       /*set a particular pixel.        */

x=20
y=50
aPIXcolor=image.x.y                    /*obtain the color of a pixel.   */
hexv=c2x(aPixcolor)                    /*get the binary value of 20,50. */
binv=x2b(hexv)                         /*get the binary value of 20,50. */

say 'pixel' x","y '=' binv             /*show the binary value of 20,50 */
bin3v=left(binv,8) substr(binv,9,8) right(binv,8)
say 'pixel' x","y '=' bin3v            /*show again, but with spaces.   */

say 'pixel' x","y '=' hexv             /*show again, but in hexadecimal.*/
hex3v=left(hexv,2) substr(hexv,3,2) right(hexv,2)
say 'pixel' x","y '=' hex3v            /*show again, but with spaces.   */

RGB=                                   /*start with a clean slate.      */
xSize=500                              /*size of the  X  axis.          */
YSize=800                              /*  "   "  "   Y    "            */

  do x=1 to xSize
      do y=1 to Ysize
      RGB=RGM || image.x.y             /*build RBG  one pixel at a time.*/
      end   /*y*/
  end       /*x*/

return RGM                             /*return the RGB image to invoker*/
