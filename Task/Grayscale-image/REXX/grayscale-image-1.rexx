/*REXX program converts a   RGB  (red─green─blue)   image to a  grayscale  image.       */
  blue= '00 00 ff'x                              /*define the blue color  (hexadecimal).*/
    @.= blue                                     /*set the entire  image  to blue color.*/
 width=  60                                      /* width of the   image  (in pixels).  */
height= 100                                      /*height  "  "      "      "   "       */

  do    col=1  for width
     do row=1  for height                        /* [↓]  C2D  convert  char ───> decimal*/
     r=  left(@.col.row, 1)    ;    r=c2d(r)     /*extract the component red  & convert.*/
     g=substr(@.col.row, 2, 1) ;    g=c2d(g)     /*   "     "      "    green "    "    */
     b= right(@.col.row, 1)    ;    b=c2d(b)     /*   "     "      "    blue  "    "    */
     @.col.row=d2c((.2126*r+.7152*g +.0722*b)%1) /*convert RGB number  ───►  grayscale. */
     end   /*row*/                               /* [↑]  D2C  convert  decimal ───> char*/
  end      /*col*/                               /* [↑]  x%1   is the same as  TRUNC(x) */
                                                 /*stick a fork in it,  we're all done. */
