/*REXX program finds and displays  N  number of anti─primes or highly─composite numbers.*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N= 20                    /*Not specified?  Then use the default.*/
maxD= 0                                          /*the maximum number of divisors so far*/
say '─index─ ──anti─prime──'                     /*display a title for the numbers shown*/
#= 0                                             /*the count of anti─primes found  "  " */
     do once=1  for 1
        do i=1  for 59                           /*step through possible numbers by twos*/
        d= #divs(i);  if d<=maxD  then iterate   /*get # divisors;  Is too small?  Skip.*/
        #= # + 1;     maxD= d                    /*found an anti─prime #;  set new minD.*/
        say center(#, 7)  right(i, 10)           /*display the index and the anti─prime.*/
        if #>=N  then leave once                 /*if we have enough anti─primes, done. */
        end   /*i*/

        do j=60  by 20                           /*step through possible numbers by 20. */
        d= #divs(j);  if d<=maxD  then iterate   /*get # divisors;  Is too small?  Skip.*/
        #= # + 1;     maxD= d                    /*found an anti─prime #;  set new minD.*/
        say center(#, 7)  right(j, 10)           /*display the index and the anti─prime.*/
        if #>=N  then leave                      /*if we have enough anti─primes, done. */
        end   /*j*/
     end      /*once*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
#divs: procedure; parse arg x 1 y                /*X and Y:  both set from 1st argument.*/
       if x<3   then return x                    /*handle special cases for one and two.*/
       if x==4  then return 3                    /*   "      "      "    " four.        */
       if x<6   then return 2                    /*   "      "      "    " three or five*/
       odd= x // 2                               /*check if   X   is  odd  or not.      */
       if odd  then      #= 1                    /*Odd?   Assume  Pdivisors  count of 1.*/
               else do;  #= 3;     y= x % 2      /*Even?     "        "        "    " 3.*/
                    end                          /* [↑]   start with known num of Pdivs.*/

                  do k=3  for x%2-3  by 1+odd  while k<y  /*for odd numbers, skip evens.*/
                  if x//k==0  then do;  #= # + 2 /*if no remainder, then found a divisor*/
                                        y= x % k /*bump  #  Pdivs,  calculate limit  Y. */
                                        if k>=y  then do; #= # - 1; leave; end  /*limit?*/
                                   end                         /*                   ___ */
                              else if k*k>x  then leave        /*only divide up to √ x  */
                  end   /*k*/                    /* [↑]  this form of DO loop is faster.*/
       return #+1                                /*bump "proper divisors" to "divisors".*/
