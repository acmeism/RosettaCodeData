/*REXX pgm converts any integer (or a range) to a van der Corput number in base 2*/
/*convert any integer (or a range) to a van der Corput number in  base 2*/

numeric digits 1000                    /*handle anything the user wants.*/
parse arg a b .                        /*obtain the number(s)  [maybe]. */
if a=='' then do;  a=0;  b=10;  end    /*if none specified, use defaults*/
if b=='' then b=a                      /*assume a "range" of a single #.*/

      do j=a to b                      /*traipse through the range.     */
      _=vdC(abs(j))                    /*convert abs value of integer.  */
      leading=substr('-',2+sign(j))    /*if needed, leading minus sign. */
      say leading || _                 /*show number (with leading -  ?)*/
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────VDC [van der Corput] subroutine─────*/
vdC: procedure;  y=x2b(d2x(arg(1)))    /*convert to  hex,  then binary. */
if y=0 then return 0                   /*zero has been converted to 0000*/
       else return '.'reverse(strip(y,"L",0))    /*heavy lifting by REXX*/
