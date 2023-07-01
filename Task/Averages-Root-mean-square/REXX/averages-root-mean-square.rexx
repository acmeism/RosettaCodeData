/*REXX program computes and displays the  root mean square (RMS)  of a number sequence. */
parse arg nums digs show .                       /*obtain the optional arguments from CL*/
if nums==''  |  nums==","  then nums=10          /*Not specified?  Then use the default.*/
if digs==''  |  digs==","  then digs=50          /* "      "         "   "   "     "    */
if show==''  |  show==","  then show=10          /* "      "         "   "   "     "    */
numeric digits digs                              /*uses  DIGS  decimal digits for calc. */
$=0;                     do j=1  for nums        /*process each of the   N   integers.  */
                         $=$ + j**2              /*sum the   squares   of the integers. */
                         end   /*j*/
                                                 /* [↓]  displays  SHOW  decimal digits.*/
rms=format( sqrt($/nums), , show ) / 1           /*divide by N, then calculate the SQRT.*/
say 'root mean square for 1──►'nums  "is: "  rms /*display the  root mean square (RMS). */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure; parse arg x;  if x=0  then return 0;  d=digits();  numeric digits;  m.=9
       numeric form;  parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;  g=g *.5'e'_ % 2
       h=d+6;    do j=0  while h>9;       m.j=h;                h=h%2+1;        end  /*j*/
                 do k=j+5  to 0  by -1;   numeric digits m.k;   g=(g+x/g)*.5;   end  /*k*/
       return g
