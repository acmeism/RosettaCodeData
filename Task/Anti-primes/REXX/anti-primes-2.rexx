/*REXX program finds and displays  N  number of anti─primes or highly─composite numbers.*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N= 20                    /*Not specified?  Then use the default.*/
         @.= .;    @.1= 1;     @.2= 2;     @.4= 3;     @.5= 2;     @.6= 4
say '─index─ ──anti─prime──'                     /*display a title for the numbers shown*/
#= 1                                             /*the count of anti─primes found  "  " */
maxD= 1                                          /*the maximum number of divisors so far*/
say center(#, 7)  right(1, 10)                   /*display the index and the anti─prime.*/
     do once=1  for 1
        do i=2  by  2  to 59                     /*step through possible numbers by twos*/
        d= #divs(i);  if d<=maxD  then iterate   /*get # divisors;  Is too small?  Skip.*/
        #= # + 1;     maxD= d                    /*found an anti─prime #;  set new minD.*/
        say center(#, 7)  right(i, 10)           /*display the index and the anti─prime.*/
        if #>=N  then leave once                 /*if we have enough anti─primes, done. */
        end   /*i*/

        do j=60  by 20                           /*step through possible numbers by 20. */
        d= #divs(j);  if d<=maxD  then iterate   /*get # divisors;  Is too small?  Skip.*/
        #= # + 1;     maxD= d                    /*found an anti─prime #;  set new minD.*/
        say center(#, 7)  right(j, 10)           /*display the index and the anti─prime.*/
        if #>=N  then leave once                 /*if we have enough anti─primes, done. */
        L= length(j)                             /*obtain the length of the index  (J). */
        if L>3  then j= j + left(4, L-2, 0) - 20 /*Length>3?  Then calculate a long jump*/
        end   /*j*/
     end      /*once*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
#divs: parse arg x;  if @.x\==.  then return @.x /*if pre─computed, then return shortcut*/
       $= 3;     y= x % 2
                                                 /* [↑]   start with known num of Pdivs.*/
                  do k=3  for x%2-3  while k<y
                  if x//k==0  then do;  $= $ + 2 /*if no remainder, then found a divisor*/
                                        y= x % k /*bump  $  Pdivs,  calculate limit  Y. */
                                        if k>=y  then do; $= $ - 1; leave; end  /*limit?*/
                                   end                         /*                   ___ */
                              else if k*k>x  then leave        /*only divide up to √ x  */
                  end   /*k*/                    /* [↑]  this form of DO loop is faster.*/
       return $+1                                /*bump "proper divisors" to "divisors".*/
