/*REXX program demonstrates how to process/display a simple  RGB  raster graphics image.*/
red   = '00000000 00000000 11111111'b            /*define a    red    value.            */
blue  = '11111111 00000000 00000000'b            /*   "   "    blue     "               */
blue  = 'ff 00 00'x                              /*another way to define a  blue  value.*/
@.    =                                          /*define entire  @.  array  to  nulls. */
             x=10;       y=40                    /*set pixel's coördinates.             */
call RGBfill      red                            /*set the entire   image   to red.     */
call RGBset x, y, blue                           /*set a pixel (at  10,40)  to blue.    */
color = RGBget(x, y)                             /*get the color of a pixel.            */
hexV  = c2x(color)                               /*get hex    value of pixel's color.   */
binV  = x2b(hexV)                                /* "  binary   "    "    "      "      */
bin3V = left(binV, 8)    substr(binV, 9, 8)    right(binV, 8)
hex3V = left(hexV, 2)    substr(hexV, 3, 2)    right(hexV, 2)
xy= '(' || x","y')'                              /*create a handy─dandy literal for SAY.*/
say  xy    ' pixel in binary: '     binV         /*show the binary value of  20,50      */
say  xy    ' pixel in binary: '     bin3V        /*show again, but with spaces.         */
say                                              /*show a blank between binary and hex. */
say  xy    ' pixel in hex:    '     hexV         /*show again, but in hexadecimal.      */
say  xy    ' pixel in hex:    '     hex3V        /*show again, but with spaces.         */
call PPMwrite 'image', 500, 500                  /*create a PPM (output) file of image. */      /* ◄■■■■■■■■ not part of this task.*/
say                                              /*show a blank.                        */
say 'The file  image.PPM   was created.'         /*inform user that a file was created. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
RGBfill:  @.=arg(1);                          return          /*fill image with a color.*/
RGBget:   parse arg px,py;                    return @.px.py  /*get a pixel's color.    */
RGBset:   parse arg px,py,p$;  @.px.py=p$;    return          /*set "    "      "       */
/*──────────────────────────────────────────────────────────────────────────────────────*/
PPMwrite: parse arg oFN, width, height           /*obtain output filename, width, height*/
          oFID= oFN'.PPM';   $='9'x;   #=255     /*fileID;  separator;  max color value.*/
          call charout oFID, ,  1                /*set the position of the file's output*/
          call charout oFID,'P6'width || $ || height || $ || # || $    /*write hdr info.*/
            do   j=1  for width
              do k=1  for height;     call charout oFID, @.j.k
              end   /*k*/                        /*  ↑          write the PPM file, ··· */
            end     /*j*/                        /*  └───────── ··· one pixel at a time.*/
          call charout oFID;      return         /*close the output file just to be safe*/
