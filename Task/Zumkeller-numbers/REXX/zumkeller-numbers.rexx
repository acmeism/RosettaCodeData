/*REXX pgm finds & shows Zumkeller numbers: 1st N; 1st odd M; 1st odd V not ending in 5.*/
parse arg n m v .                                /*obtain optional arguments from the CL*/
if n=='' | n==","  then n= 220                   /*Not specified?  Then use the default.*/
if m=='' | m==","  then m=  40                   /* "      "         "   "   "     "    */
if v=='' | v==","  then v=  40                   /* "      "         "   "   "     "    */
@zum= ' Zumkeller numbers are: '                 /*literal used for displaying messages.*/
sw= linesize() - 1                               /*obtain the usable screen width.      */
say
if n>0  then say center(' The first '       n       @zum,  sw, "═")
#= 0                                             /*the count of Zumkeller numbers so far*/
$=                                               /*initialize the  $  list  (to a null).*/
        do j=1  until #==n                       /*traipse through integers 'til done.  */
        if \Zum(j)  then iterate                 /*if not a Zumkeller number, then skip.*/
        #= # + 1;           call add$            /*bump Zumkeller count;  add to $ list.*/
        end   /*j*/

if $\==''  then say $                            /*Are there any residuals? Then display*/
say
if m>0  then say center(' The first odd '   m       @zum,  sw, "═")
#= 0                                             /*the count of Zumkeller numbers so far*/
$=                                               /*initialize the  $  list  (to a null).*/
        do j=1  by 2  until #==m                 /*traipse through integers 'til done.  */
        if \Zum(j)  then iterate                 /*if not a Zumkeller number, then skip.*/
        #= # + 1;           call add$            /*bump Zumkeller count;  add to $ list.*/
        end   /*j*/

if $\==''  then say $                            /*Are there any residuals? Then display*/
say
if v>0  then say center(' The first odd '   v       " (not ending in 5) " @zum,  sw, '═')
#= 0                                             /*the count of Zumkeller numbers so far*/
$=                                               /*initialize the  $  list  (to a null).*/
        do j=1  by 2  until #==v                 /*traipse through integers 'til done.  */
        if right(j,1)==5  then iterate           /*skip if odd number ends in digit "5".*/
        if \Zum(j)  then iterate                 /*if not a Zumkeller number, then skip.*/
        #= # + 1;           call add$            /*bump Zumkeller count;  add to $ list.*/
        end   /*j*/

if $\==''  then say $                            /*Are there any residuals? Then display*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
add$: _= strip($ j, 'L');   if length(_)<sw  then do;  $= _;  return;  end    /*add to $*/
      say  strip($, 'L');                              $= j;  return          /*say, add*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  r= 0;  q= 1;                    do while q<=x; q=q*4;  end
          do while q>1; q= q%4; _= x-r-q; r= r%2; if _>=0  then do; x= _; r= r+q; end; end
       return r                                  /*R  is the integer square root of  X. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
PDaS: procedure; parse arg x 1 b;  odd= x//2     /*obtain  X  and  B (the 1st argument).*/
      if x==1  then return 1 1                   /*handle special case for unity.       */
      r= iSqrt(x)                                /*calculate integer square root of  X. */
      a= 1                                       /* [↓]  use all, or only odd numbers.  */
      sig= a + b                                 /*initialize the sigma  (so far)   ___ */
          do j=2+odd  by 1+odd  to r - (r*r==x)  /*divide by some integers up to   √ X  */
          if x//j==0  then do;  a=a j;  b= x%j b /*if ÷, add both divisors to α & ß.    */
                                sig= sig +j +x%j /*bump the sigma (the sum of divisors).*/
                           end
          end   /*j*/                            /* [↑]  %  is the REXX integer division*/
                                                 /* [↓]  adjust for a square.        ___*/
      if j*j==x  then  return sig+j  a j b       /*Was  X  a square?    If so, add  √ X */
                       return sig    a   b       /*return the divisors  (both lists).   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Zum:  procedure; parse arg x .                   /*obtain a # to be tested for Zumkeller*/
      if x<6    then return 0                    /*test if X is too low     "      "    */
      if x<945  then if x//2==1  then return 0   /*  "   " "  "  "   "  for odd    "    */
      parse value  PDaS(x)  with  sigma pdivs    /*obtain sigma and the proper divisors.*/
      if sigma//2  then return 0                 /*Is the  sigma  odd?    Not Zumkeller.*/
      #= words(pdivs)                            /*count the number of divisors for  X. */
      if #<3       then return 0                 /*Not enough divisors?    "      "     */
      if x//2      then do; _= sigma - x - x     /*use abundant optimization for odd #'s*/
                            return _>0 & _//2==0 /*Abundant is > 0 and even?  It's a Zum*/
                        end
      if #>23      then return 1                 /*# divisors is 24 or more?  It's a Zum*/

           do i=1  for #;   @.i= word(pdivs, i)  /*assign proper divisors to the @ array*/
           end   /*i*/
      c=0;            u= 2**#;   !.= .
          do p=1  for u-2;       b= x2b(d2x(p))  /*convert P──►binary with leading zeros*/
          b= right(strip(b, 'L', 0), #, 0)       /*ensure enough leading zeros for  B.  */
          r= reverse(b); if !.r\==. then iterate /*is this binary# a palindrome of prev?*/
          c= c + 1;   yy.c= b;   !.b=            /*store this particular combination.   */
          end   /*p*/

          do part=1  for c;      p1= 0;   p2= 0  /*test of two partitions add to same #.*/
          _= yy.part                             /*obtain one method of partitioning.   */
            do cp=1  for #                       /*obtain the sums of the two partitions*/
            if substr(_, cp, 1)  then p1= p1 + @.cp     /*if a  one, then add it to  P1.*/
                                 else p2= p2 + @.cp     /* " " zero,   "   "   "  "  P2.*/
            end   /*cp*/
          if p1==p2  then return 1               /*Partition sums equal?  Then X is Zum.*/
          end   /*part*/
      return 0                                   /*no partition sum passed.  X isn't Zum*/
