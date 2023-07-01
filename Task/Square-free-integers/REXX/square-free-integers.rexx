/*REXX program displays  square─free numbers  (integers > 1)  up to a specified limit.  */
numeric digits 20                                /*be able to handle larger numbers.    */
parse arg LO HI .                                /*obtain optional arguments from the CL*/
if LO=='' | LO==","  then LO=   1                /*Not specified?  Then use the default.*/
if HI=='' | HI==","  then HI= 145                /* "      "         "   "   "     "    */
sw= linesize() - 1                               /*use one less than a full line.       */
# = 0                                            /*count of square─free numbers found.  */
$=                                               /*variable that holds a line of numbers*/
     do j=LO  to abs(HI)                         /*process all integers between LO & HI.*/
     if \isSquareFree(j)   then iterate          /*Not square─free?   Then skip this #. */
     #= # + 1                                    /*bump the count of square─free numbers*/
     if HI<0  then iterate                       /*Only counting 'em? Then look for more*/
     if length($ || j)<sw  then $= strip($ j)    /*append the number to the output list.*/
                           else do;   say $;   $=j;   end   /*display a line of numbers.*/
     end   /*j*/

if $\==''  then say $                            /*are there any residuals to display ? */
@theNum= 'The number of square─free numbers between '
if HI<0    then say @theNum  LO      " and "      abs(HI)       ' (inclusive)  is: '     #
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isSquareFree: procedure; parse arg x;  if x<1  then return 0  /*is the number too small?*/
              odd= x//2                          /*ODD=1   if X is odd,   ODD=0 if even.*/
                       do k=2+odd  to iSqrt(x)  by 1+odd /*use all numbers, or just odds*/
                       if x // k**2 == 0  then return 0  /*Is  X  divisible by a square?*/
                       end   /*k*/                       /* [↑]  Yes? Then ¬ square─free*/
              return 1                           /* [↑]       //  is REXX's ÷ remainder.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;         q= 1;         do while q<=x;       q= q * 4
                                                     end   /*while q<=x*/
       r= 0
                  do while q>1;        q= q % 4;     _= x - r - q;        r= r % 2
                  if _>=0  then do;    x= _;         r= r + q;            end
                  end   /*while q>1*/
       return r                                  /*R  is the integer square root of  X. */
