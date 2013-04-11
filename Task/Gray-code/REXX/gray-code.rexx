/*REXX program to convert decimal───> binary ───> gray code ───> binary.*/
parse arg N .;    if N=='' then N=31   /*Not specified? Then use default*/
L=max(1,length(strip(x2b(d2x(N)),'L',0)))   /*for cell width formatting.*/
w=14                                   /*used for cell width formatting.*/
_=center('binary',w,'─')               /*2nd and 4th part of the header.*/
say center('decimal',w,'─')">" _">" center('gray code',w,'─')">" _ /*hdr*/

     do j=0  to N;     b=right(x2b(d2x(j)),L,0)      /*handle 0  ──►  N.*/
     g=b2gray(b)                       /*convert binary to gray code.   */
     a=gray2b(g)                       /*convert gray code to binary.   */
     say center(j,w+1) center(b,w+1) center(g,w+1) center(a,w+1)  /*tell*/
     end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────B2GRAY subroutine──────────────────*/
b2gray: procedure; parse arg x
$=left(x,1);                    do b=2  to length(x)
                                $=$||(substr(x,b-1,1) && substr(x,b,1))
                                end   /*b*/        /* && is eXclusive OR*/
return $
/*───────────────────────────────────GRAY2B subroutine──────────────────*/
gray2b: procedure; parse arg x
$=left(x,1);                    do g=2  to length(x)
                                $=$ || (right($,1)    && substr(x,g,1))
                                end   /*g*/        /* && is eXclusive OR*/
return $
