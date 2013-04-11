/*REXX program to show a     DO  WHILE     construct. */
x=1024
         do while x>0
         say right(x,10)      /*pretty up the output by aligning.*/
         x=x%2                /*in REXX, %  is integer division. */
         end
