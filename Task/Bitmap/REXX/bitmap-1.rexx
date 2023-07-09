/*REXX program demonstrates how to process/display                     */
/*                                a simple  RGB  raster graphics image.*/
red   = 'ff 00 00'x             /*a method to define a   red   value.  */
blue  = '00 00 ff'x             /*'    '    '    '   '   blue    '     */
pixel=''                        /*define entire  pixel. array to nulls.*/
outFN = 'image'                 /*the filename of the output image PPM */
sWidth = 500; sHeight= 500      /*the screen width and height in pixels*/
Call RGBfill red                /*set the entire   image   to red.     */
x=10; y=40                      /*set pixel's coördinates.             */
Call RGBset x,y,blue            /*set a pixel (at  10,40)  to blue.    */
color = RGBget(x,y)             /*get the color of a pixel.            */
hexV  = c2x(color)              /*get hex    value of pixel's color.   */
binV  = x2b(hexV)               /* "  binary   "    "    "      "      */
bin3V = left(binV,8) substr(binV,9,8) right(binV,8)
hex3V = left(hexV,2) substr(hexV,3,2) right(hexV,2)
xy= '('||x','y')'               /*create a handy-dandy literal for SAY.*/
Say xy ' pixel in binary: ' binV   /*show the binary value of  20,50   */
Say xy ' pixel in binary: ' bin3V  /*show again,but with spaces.       */
Say                                /*show a blank between bin & hex.   */
Say xy ' pixel in hex:    ' hexV   /*show again,but in hexadecimal.    */
Say xy ' pixel in hex:    ' hex3V  /*show again,but with spaces.       */
Call PPMwrite outFN,sWidth,sHeight /*create a PPM (output) file        */
    /* ?¦¦¦¦¦¦¦¦ not part of this task.*/
Say                                      /*show a blank.               */
Say 'The file ' outFN'.PPM was created.' /*inform user                 */
Exit                             /*stick a fork in it, we're all done. */
/*---------------------------------------------------------------------*/
RGBfill: pixel.=arg(1);   Return             /*fill image with a color.*/
RGBget:  Parse arg px,py; Return pixel.px.py /*get a pixel's color.    */
RGBset:  Parse arg px,py,psep; pixel.px.py=psep; Return /*set a pixel  */
/*---------------------------------------------------------------------*/
PPMwrite: Parse arg oFN,width,height
  oFID= oFN'.PPM'               /* fileID                              */
  sep='9'x;                     /* separator                           */
  maxcol=255                    /* max color value.                    */
  Call charout oFID,,1          /*set the position of the file's output*/
  Call charout oFID,'P6'width||sep||height||sep||maxcol||sep /* header */
  Do i=1 To width
    Do j=1 To height;
      Call charout oFID,pixel.i.j
      End
    End
  Call charout oFID           /* close the output file just to be safe */
  Return
