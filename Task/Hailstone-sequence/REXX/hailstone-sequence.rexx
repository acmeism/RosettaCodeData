/*REXX pgm tests a number and a range for hailstone (Collatz) sequences.*/
parse arg x .;  if x=='' then x=27     /*get the optional first argument*/
numeric digits 20
$=hailstone(x)                         /*═════════════task 1════════════*/
say x 'has a hailstone sequence of' #hs 'and starts with: ' subword($,1,4),
                                       ' and ends with:'  subword($,#hs-3)
say
w=0;         do j=1  for 99999         /*═════════════task 2════════════*/
             call hailstone j          /*compute the hailstone sequence.*/
             if #hs<=w  then iterate   /*Not big 'nuff? Then keep going.*/
             bigJ=j;    w=#hs          /*remember what # has biggest HS.*/
             end   /*j*/

say '(between 1──►99,999) '  bigJ  'has the longest hailstone sequence:' w
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HAILSTONE subroutine────────────────*/
hailstone: procedure expose #hs; parse arg n 1 s  /*N & S set to 1st arg*/

           do #hs=1  while n\==1       /*loop while  N  isn't  unity.   */
           if n//2  then n=n*3+1       /*if  N  is odd,  calc:   3*n +1 */
                    else n=n%2         /* "  "   " even, perform fast ÷ */
           s=s n                       /*build a sequence list (append).*/
           end   /*#hs*/
return s
