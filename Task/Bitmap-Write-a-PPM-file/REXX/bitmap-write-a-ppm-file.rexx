/*REXX program to write a  PPM  formatted image file,  P6 (binary).     */
oFID   = 'IMAGE.PPM'                   /*name of the output file.       */
green  = '00 ff 00'x
image. = green                         /*define all IMAGE RGB's to green*/
 width = 20                            /*define the  width of  IMAGE.   */
height = 20                            /*  "     "  height  "    "      */
   sep = '9'x
call put 'P6'width||sep||height||sep||255||sep      /*write header info.*/

  do j      =1  for width
        do k=1  for height
        call put image.j.k             /*write IMAGE, 3 bytes at a time.*/
        end   /*k*/
  end         /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────subroutines──────────────────────*/
put:  call charout oFID,arg(1); return /*write out character(s) to file.*/
