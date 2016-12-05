/*REXX program tests a  number  and also a  range for  hailstone  (Collatz)  sequences. */
!.=0;     !.0=1;  !.2=1;  !.4=1;  !.6=1;  !.8=1  /*assign even numerals to be  "true".  */
numeric digits 20;  @.=0                         /*handle big numbers; initialize array.*/
parse arg x y z .;  !.h=y                        /*get optional arguments from the C,L. */
if x=='' | x==","   then x=    27                /*No  1st  argument?  Then use default.*/
if y=='' | y==","   then y=100000 - 1            /* "  2nd      "        "   "     "    */
if z=='' | z==","   then z=    12                /*head/tail number?     "   "     "    */
hm=max(y, 40000)                                 /*use memoization (maximum num for  @.)*/
$=hailstone(x)      /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒task 1▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
say  x   ' has a hailstone sequence of '         words($)
say      '    and starts with: '                 subword($, 1, z)    " ∙∙∙"
say      '    and  ends  with:  ∙∙∙'             subword($, max(z+1, words($)-z+1))
if y==0  then exit  /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒task 2▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
say
w=0;         do j=1  for y;  $=hailstone(j)      /*traipse through the range of numbers.*/
             #hs=words($)                        /*find the length of the hailstone seq.*/
             if #hs<=w  then iterate             /*Not big enough?  Then keep traipsing.*/
             bigJ=j;    w=#hs                    /*remember what # has biggest hailstone*/
             end   /*j*/
say '(between 1 ──►'   y") "        bigJ       ' has the longest hailstone sequence: '   w
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hailstone: procedure expose @. !. hm;  parse arg n 1 s 1 o,@.1  /*N,S,O: are the 1st arg*/
                       do  while @.n==0          /*loop while the residual is unknown.  */
                       parse var  n  ''  -1  L   /*extract the last decimal digit of  N.*/
                       if !.L  then n=n%2        /*N is even?   Then calculate  fast ÷  */
                               else n=n*3 + 1    /*?  ? odd ?   Then calculate  3*n + 1 */
                       s=s  n                    /* [↑]  %: is the REXX integer division*/
                       end   /*while*/           /* [↑]  append  N  to the sequence list*/
           s=s  @.n                              /*append the number to a sequence list.*/
           @.o=subword(s, 2);    parse var s _ r /*use memoization for this hailstone #.*/
              do  while r\=='';  parse var r _ r /*obtain the next  hailstone sequence. */
              if @._\==0  then leave             /*Was number already found?  Return  S.*/
              if _>hm     then iterate           /*Is  number  out of range?  Ignore it.*/
              @._=r                              /*assign subsequence number to array.  */
              end   /*while*/
           return s
