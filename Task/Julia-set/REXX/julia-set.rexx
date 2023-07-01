/*REXX program  displays  an  ASCII plot   (character plot)   of a  Julia set.          */
parse arg real imag fine .                       /*obtain optional arguments from the CL*/
if real=='' | real==","  then real= -0.8         /*Not specified?  Then use the default.*/
if imag=='' | imag==","  then imag=  0.156       /* "      "         "   "   "     "    */
if fine=='' | fine==","  then fine= 50           /* "      "         "   "   "     "    */
_=scrsize(); parse var _ sd sw; sd=sd-4; sw=sw-1 /*obtain useable area for the terminal.*/
                                                 /*$:  the plot line that is constructed*/
         do   v= -sd%2  to sd%2;     $=          /*step through  vertical   axis values.*/
           do h= -sw%2  to sw%2                  /*  "     "    horizontal    "     "   */
           x=h/sw*2                              /*calculate the initial   X   value.   */
           y=v/sd*2                              /*    "      "     "      Y     "      */
           @='■';    do fine                     /*FINE: is the "fineness" for the plot.*/
                     zr=x*x - y*y + real         /*calculate a new   real   Julia point.*/
                     zi=x*y*2     + imag         /*    "     "  "  imaginal   "     "   */
                     if zr**2>10000  then do; @=' '; leave; end    /*is  ZR  too large? */
                     x=zr;    y=zi                                 /*use this new point.*/
                     end   /*50*/
           $=$ || @                              /*append the plot char to the plot line*/
           end            /*h*/
         if $\=''  then say strip($, 'T')        /*only display a plot line if non-blank*/
         end   /*v*/                             /*stick a fork in it,  we're all done. */
