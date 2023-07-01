/*REXX program converts decimal number ───► binary ───► gray code ───► binary.*/
parse arg N .                          /*get the optional argument from the CL*/
if N==''  | N==","   then N=31         /*Not specified?  Then use the default.*/
L=max(1,length(strip(x2b(d2x(N)),'L',0)))   /*find the max binary length of N.*/
w=14                                   /*used for the formatting of cell width*/
_=center('binary',w,'─')               /*the  2nd and 4th  part of the header.*/
say center('decimal', w, "─")'►'     _"►"    center('gray code', w, '─')"►"    _
                                                     /* [+]  the output header*/
     do j=0  to N;     b=right(x2b(d2x(j)),L,0)      /*process   0  ──►  N.   */
     g=b2gray(b)                       /*convert binary number to gray code.  */
     a=gray2b(g)                       /*convert the gray code to binary.     */
     say center(j,w+1)   center(b,w+1)   center(g,w+1)   center(a,w+1)
     end   /*j*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
b2gray: procedure; parse arg x 1 $ 2;    do b=2  to length(x)
                                         $=$||(substr(x,b-1,1) && substr(x,b,1))
                                         end   /*b*/
        return $
/*────────────────────────────────────────────────────────────────────────────*/
gray2b: procedure; parse arg x 1 $ 2;    do g=2  to length(x)
                                         $=$ || (right($,1)    && substr(x,g,1))
                                         end   /*g*/        /*  ↑  */
                                                            /*  │  */
        return $           /*this is an eXclusive OR  ►─────────┘  */
