/*REXX program draws a  Sierpinski triangle  of up to around order 10k. */
parse arg n mk .                       /*get the order of the triangle. */
if n=='' | n==',' then n=4             /*if none specified, assume  4.  */
if mk==''         then mk='*'          /*use the default of an asterisk.*/
if length(mk)==2  then mk=x2c(mk)      /*MK was specified in hexadecimal*/
if length(mk)==3  then mk=d2c(mk)      /*MK was specified in decimal.   */
numeric digits 12000                   /*this otta handle the die-hards.*/

   do j=0  for n*4;  !=1;  z=left('',n*4-1-j)        /*indent the line. */
             do k=0  to j              /*build the line with  J+1  parts*/
             if !//2==0  then z=z'  '  /*it's either a blank,  or  ...  */
                         else z=z mk   /*it's one of them thar character*/
             !=!*(j-k)%(k+1)           /*calculate a handy-dandy thingy.*/
             end   /*k*/
   say z                               /*display a line of the triangle.*/
   end             /*j*/
                                       /*stick a fork in it, we're done.*/
