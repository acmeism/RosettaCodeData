/*REXX pgm tests a number and also a range for hailstone (Collatz) sequences. */
!.=0; !.0=1; !.2=1; !.4=1; !.6=1; !.8=1    /*assign even digits to be "true". */
numeric digits 20;  @.=0               /*handle big numbers; initialize array.*/
parse arg x y z .;  !.h=y              /*get optional arguments from the C,L. */
if x=='' | x==','   then x=27          /*No  1st  argument?  Then use default.*/
if y=='' | y==','   then y=100000-1    /* "  2nd      "        "   "     "    */
if z=='' | z==','   then z=12          /*head/tail number?     "   "     "    */
$=hailstone(x)      /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒task 1▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
say x   ' has a hailstone sequence of '    words($)
say '     and starts with: '       subword($, 1, z)    " ∙∙∙"
say '     and  ends  with:  ∙∙∙'   subword($, max(z+1, words($)-z+1))
say                                    /*Z:  show first & last Z numbers*/
if y==0  then exit  /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒task 2▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
w=0;         do j=1  for y             /*traipse through the range of numbers.*/
             $=hailstone(j)            /*compute the hailstone sequence for J.*/
             #hs=words($)              /*find the length of the hailstone seq.*/
             if #hs<=w  then iterate   /*Not big 'nuff?   Then keep traipsing.*/
             bigJ=j;    w=#hs          /*remember what # has biggest hailstone*/
             end   /*j*/
say '(between 1──►'y") "      bigJ     ' has the longest hailstone sequence:'  w
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HAILSTONE subroutine──────────────────────*/
hailstone: procedure expose @. !.;  parse arg n 1 s 1 o   /*N,S,O are 1st arg.*/
@.1=                                   /*handle the special case for unity (1)*/
           do  while @.n==0            /*loop while the residual is unknown.  */
           parse var  n  ''  -1 L      /*extract the last decimal digit of  N.*/
           if !.L  then n=n%2          /*N is even?   Then calculate  fast ÷  */
                   else n=n*3 + 1      /*?  ? odd ?   Then calculate  3*n + 1 */
           s=s n                       /* [↑]  %: is the REXX integer division*/
           end   /*#hs*/               /* [↑]  append  N  to the sequence list*/
s=s @.n                                /*append the number to a sequence list.*/
@.o=subword(s,2)                       /*use memoization for this hailstone #.*/
r=s; h=!.h
           do  while  r\=='';  parse var r _ r    /*get next the subsequence. */
           if @._\==0  then return s              /*Already found?  Return S. */
           if _>!      then return s              /*Out of range?   Return S. */
           @._=r                                  /*assign the subsequence #. */
           end   /*while*/
