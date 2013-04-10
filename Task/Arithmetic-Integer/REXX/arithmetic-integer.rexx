/*REXX pgm gets 2 integers from the C.L. or via prompt, shows some opers*/
numeric digits 20                      /*all numbers are rounded at ··· */
                                       /*··· the 20th significant digit.*/
parse arg x y .                        /*maybe the integers are on C.L.?*/
if y==''  then do                      /*nope, then prompt user for 'em.*/
               say "─────Enter two integer values  (separated by blanks):"
               parse pull x y .
               end
     do 2                              /*show  A with B, then  B with A.*/
     say                               /*show blank line for eyeballing.*/

     call show 'addition'      , "+",  x+y
     call show 'subtraction'   , "-",  x-y
     call show 'multiplication', "*",  x*y
     call show 'int  division' , "%",  x%y,   '   [rounds down]'
     call show 'real division' , "/",  x/y
     call show 'div remainder' , "//", x//y, '    [sign from 1st operand]'
     call show 'power'         , "**", x**y

     parse value  x y  with  y x       /*swap the two values & do again.*/
     end   /*2*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOW subroutine─────────────────────*/
show: parse arg what,oper,value,comment
say right(what,25)' '   x  center(oper,4)  y    ' ───► '    value  comment
return
