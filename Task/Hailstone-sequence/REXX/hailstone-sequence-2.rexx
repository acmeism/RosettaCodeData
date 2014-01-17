/*REXX pgm tests a number and a range for hailstone (Collatz) sequences.*/
parse arg x y .                        /*get optional arguments from CL.*/
if x=='' | x==','   then x=27          /*Any 1st argument?  Use default.*/
if y=='' | y==','   then y=99999       /*Any 2nd argument?  Use default.*/
numeric digits 20;  @.=0               /*handle big #s; initialize array*/
$=hailstone(x)      /*═══════════════════task 1═════════════════════════*/
say x   ' has a hailstone sequence of '    words($)
say '     and starts with: '       subword($, 1, 4)    " ∙∙∙"
say '     and  ends  with:  ∙∙∙'   subword($, max(1, words($)-3))
say
if y==0 then exit   /*═══════════════════task 2═════════════════════════*/
w=0;         do j=1  for y             /*loop through all numbers <100k.*/
             $=hailstone(j)            /*compute the hailstone sequence.*/
             #hs=words($)              /*find the length of the sequence*/
             if #hs<=w  then iterate   /*Not big 'nuff? Then keep going.*/
             bigJ=j;    w=#hs          /*remember what # has biggest HS.*/
             end   /*j*/
say '(between 1──►'y") "   bigJ   ' has the longest hailstone sequence:' w
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HAILSTONE subroutine────────────────*/
hailstone: procedure expose @.; parse arg n 1 s 1 o  /*N,S,O  = 1st arg.*/
@.1=                                   /*special case for unity.        */
           do  forever                 /*loop while  N  isn't  unity.   */
           if @.n\==0  then do; s=s @.n; leave; end  /*been here before?*/
           if n//2  then n=n*3+1       /*if  N  is odd,  calc:   3*n +1 */
                    else n=n%2         /* "  "   " even, perform fast ÷ */
           s=s n                       /*build a sequence list (append).*/
           end   /*forever*/
@.o=subword(s,2)                       /*memoization for this hailstone.*/
return s
