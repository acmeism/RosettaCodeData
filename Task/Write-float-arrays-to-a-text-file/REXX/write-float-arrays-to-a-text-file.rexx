/*REXX program writes  two arrays  to a file  with  limited precision,  */
numeric digits 1000                /* ··· but allow a huge # of digits. */
outfid = 'OUTPUT.TXT'              /*file name structure is OS dependent*/
                x.  =        ;     y.  =
                x.1 = 1      ;     y.1 = 1
                x.2 = 2      ;     y.2 = 1.4142135623730951
                x.3 = 3      ;     y.3 = 1.7320508075688772
                x.4 = 1e11   ;     y.4 = 316227.76601683791
xPrecision = 3                         /*precision for the  X  numbers. */
yPrecision = 5                         /*    "      "   "   Y     "     */
padding=left('',4)                     /*number of blanks between cols. */
                    do j=1  while  x.j\==''       /*process all numbers.*/
                    x.j=req_way(x.j, xPrecision)  /*format the X numbers*/
                    y.j=req_way(y.j, yPrecision)  /*   "    "  Y    "   */
                    aLine=translate(x.j || padding || y.j,    'e',   "E")
                    say aLine                     /*display to terminal.*/
                    call lineout outfid,aLine     /*write to disk file. */
                    end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────REQ_WAY (required) subroutine───────*/
req_way:  procedure;  parse arg a,p;   numeric digits p;   a=format(a,,p)
parse var a  mantissa      'E'  expon  /*obtain the exponent digits.    */
parse var    mantissa int  '.'  fract  /*   "    "  integer & fraction. */
fract=strip(fract, 'T', 0)             /*strip trailing zeros from frac.*/
if fract\==''  then fract='.'fract     /*if fraction digits, add decimal*/
if expon\==''  then expon='E'expon     /* " exponent    "     "  an  E  */
a=int || fract || expon                /*format # according to the rules*/
if datatype(a,'W')  then return format(arg(1)/1,,0)     /*whole number? */
                         return format(arg(1)/1,,,3,0)  /*use 3 dec digs*/
