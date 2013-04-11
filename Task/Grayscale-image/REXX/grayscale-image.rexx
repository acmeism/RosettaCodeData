/*REXX program to convert a RGB image to grayscale.                     */
blue='00 00 ff'x                       /*define the blue color.         */
image.=blue                            /*set the entire IMAGE to blue.  */
 width= 60                             /* width of the IMAGE.           */
height=100                             /*height  "  "    "              */

  do   j=1  for width
    do k=1  for height
    r=  left(image.j.k,1)      ;  r=c2d(r)     /*extract red   & convert*/
    g=substr(image.j.k,2,1)    ;  g=c2d(g)     /*   "    green "    "   */
    b= right(image.j.k,1)      ;  b=c2d(b)     /*   "    blue  "    "   */
    ddd=right(trunc(.2126*r + .7152*g + .0722*b),3,0)   /*──► greyscale.*/
    image.j.k=right(d2c(ddd,6),3,0)            /*... and transform back.*/
    end   /*j*/
  end     /*k*/
                                       /*stick a fork in it, we're done.*/
