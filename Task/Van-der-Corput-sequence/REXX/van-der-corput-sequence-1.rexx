/*REXX pgm converts an integer (or a range)──►van der Corput # in base 2*/
numeric digits 1000                    /*handle anything the user wants.*/
parse arg a b .                        /*obtain the number(s)  [maybe]. */
if a==''  then do;  a=0;  b=10;  end   /*if none specified, use defaults*/
if b==''  then b=a                     /*assume a "range" of a single #.*/

      do j=a  to b                     /*traipse through the range.     */
      _=vdC(abs(j))                    /*convert  ABS  value of integer.*/
      leading=substr('-',2+sign(j))    /*if needed,  elide leading sign.*/
      say leading || _                 /*show number (with leading -  ?)*/
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────VDC [van der Corput] subroutine─────*/
vdC: procedure;  y=x2b(d2x(arg(1)))+0  /*convert to  hex,  then binary. */
if y==0  then return 0                 /*handle special case of zero.   */
         else return '.'reverse(y)     /*heavy lifting by REXX*/
