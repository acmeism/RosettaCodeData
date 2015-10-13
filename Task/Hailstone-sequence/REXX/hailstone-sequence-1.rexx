/*REXX pgm tests a number and also a range for hailstone (Collatz) sequences. */
numeric digits 20                      /*be able to handle gihugeic numbers.  */
parse arg x y .                        /*get optional arguments from the C.L. */
if x=='' | x==','   then x=27          /*No  1st  argument?  Then use default.*/
if y=='' | y==','   then y=100000-1    /* "  2nd      "        "   "     "    */
$=hailstone(x)      /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒task 1▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
say x   ' has a hailstone sequence of '    words($)
say '     and starts with: '               subword($, 1, 4)    " ∙∙∙"
say '     and  ends  with:  ∙∙∙'           subword($, max(5, words($)-3))
if y==0  then exit  /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒task 2▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
say
w=0;         do j=1  for y             /*traipse through the range of numbers.*/
             call hailstone  j         /*compute the hailstone sequence for J.*/
             if #hs<=w  then iterate   /*Not big 'nuff?   Then keep traipsing.*/
             bigJ=j;    w=#hs          /*remember what # has biggest hailstone*/
             end   /*j*/
say '(between 1──►'y") "      bigJ     ' has the longest hailstone sequence:'  w
say 'and took'
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────HAILSTONE subroutine──────────────────────*/
hailstone: procedure expose #hs; parse arg n 1 s  /*N & S  are set to 1st arg.*/

           do #hs=1   while  n\==1     /*keep loop while   N   isn't  unity.  */
           if n//2  then n=n*3 + 1     /*N is odd ?   Then calculate  3*n + 1 */
                    else n=n%2         /*"  " even?   Then calculate  fast ÷  */
           s=s n                       /* [↑]  %   is REXX integer division.  */
           end   /*#hs*/               /* [↑]  append  N  to the sequence list*/
return s                               /*return the  S  string to the invoker.*/
