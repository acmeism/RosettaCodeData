/*REXX program finds and displays   N   numbers of the   "anti─primes plus"   sequence. */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N= 15                    /*Not specified?  Then use the default.*/
idx= 1                                           /*the maximum number of divisors so far*/
say '──index──  ──anti─prime plus──'             /*display a title for the numbers shown*/
#= 0                                             /*the count of anti─primes found  "  " */
        do i=1  until #==N                       /*step through possible numbers by twos*/
        d= #divs(i);  if d\==idx  then iterate   /*get # divisors;  Is too small?  Skip.*/
        #= # + 1;     idx= idx + 1               /*found an anti─prime #;  set new minD.*/
        say center(#, 8)  right(i, 15)           /*display the index and the anti─prime.*/
        end   /*i*/
exit 0                                            /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
#divs: procedure; parse arg x 1 y                /*X and Y:  both set from 1st argument.*/
       if x<7  then do                           /*handle special cases for numbers < 7.*/
                    if x<3   then return x       /*   "      "      "    "  one and two.*/
                    if x<5   then return x - 1   /*   "      "      "    "  three & four*/
                    if x==5  then return 2       /*   "      "      "    "  five.       */
                    if x==6  then return 4       /*   "      "      "    "  six.        */
                    end
       odd= x // 2                               /*check if   X   is  odd  or not.      */
       if odd  then      #= 1;                   /*Odd?   Assume  Pdivisors  count of 1.*/
               else do;  #= 3;    y= x % 2       /*Even?     "        "        "    " 3.*/
                    end                          /* [↑]  Even,  so add 2 known divisors.*/
                                                 /* [↓] start with known number of Pdivs*/
          do k=3  for x%2-3  by 1+odd  while k<y /*for odd numbers, skip over the evens.*/
          if x//k==0  then do                    /*if no remainder, then found a divisor*/
                           #= # + 2;   y= x % k  /*bump the # Pdivs;  calculate limit Y.*/
                           if k>=y  then do;   #= # - 1;   leave
                                         end     /* [↑]  has the limit been reached?    */
                           end                   /*                         ___         */
                      else if k*k>x  then leave  /*only divide up to the   √ x          */
          end   /*k*/                            /* [↑]  this form of DO loop is faster.*/
       return # + 1                              /*bump "proper divisors" to "divisors".*/
