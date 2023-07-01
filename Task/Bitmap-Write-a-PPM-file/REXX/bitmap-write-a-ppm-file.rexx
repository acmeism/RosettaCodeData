/*REXX program writes a  PPM  formatted image file, also known as a  P6  (binary) file. */
green  = 00ff00                                  /*define a pixel with the color green. */
parse arg oFN width height color .               /*obtain optional arguments from the CL*/
if    oFN=='' |    oFN==","  then    oFN='IMAGE' /*Not specified?  Then use the default.*/
if  width=='' |  width==","  then  width=   20   /* "      "         "   "   "     "    */
if height=='' | height==","  then height=   20   /* "      "         "   "   "     "    */
if  color=='' |  color==","  then  color= green  /* "      "         "   "   "     "    */
oFID= oFN'.PPM'                                  /*define  oFID  by adding an extension.*/
 @. = x2c(color)                                 /*set all pixels of image a hex color. */
 $  = '9'x                                       /*define the separator (in the header).*/
 #  = 255                                        /*  "     "  max value for all colors. */
call charout oFID, ,  1                          /*set the position of the file's output*/
call charout oFID,'P6'width || $ || height || $ || # || $     /*write file header info. */
_=
       do j     =1  for width
            do k=1  for height;  _= _ || @.j.k   /*write the PPM file, 1 pixel at a time*/
            end   /*k*/                          /* ↑    a pixel contains three bytes,  */
       end        /*j*/                          /* └────which defines the pixel's color*/
call charout oFID, _                             /*write the image's raster to the file.*/
call charout oFID                                /*close the output file just to be safe*/
                                                 /*stick a fork in it,  we're all done. */
