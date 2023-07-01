/*REXX program constructs and displays a  Sierpinski triangle of up to around order 10k.*/
parse arg n mark .                               /*get the order of Sierpinski triangle.*/
if n==''   | n==","  then n=4                    /*Not specified?  Then use the default.*/
if mark==''          then mark=  "*"             /*MARK  was specified as  a character. */
if length(mark)==2   then mark=x2c(mark)         /*  "    "      "     in  hexadecimal. */
if length(mark)==3   then mark=d2c(mark)         /*  "    "      "      "      decimal. */
numeric digits 12000                             /*this should handle the biggy numbers.*/
                                                 /* [↓]  the blood-'n-guts of the pgm.  */
   do j=0  for n*4;  !=1;  z=left('', n*4 -1-j)  /*indent the line to be displayed.     */
         do k=0  for j+1                         /*construct the line with  J+1  parts. */
         if !//2==0  then z=z'  '                /*it's either a    blank,   or    ···  */
                     else z=z mark               /* ··· it's one of 'em thar characters.*/
         !=! * (j-k) % (k+1)                     /*calculate handy-dandy thing-a-ma-jig.*/
         end   /*k*/                             /* [↑]  finished constructing a line.  */
   say z                                         /*display a line of the triangle.      */
   end         /*j*/                             /* [↑]  finished showing triangle.     */
                                                 /*stick a fork in it,  we're all done. */
