/*REXX program finds and displays  the   smallest number   with  exactly   N   divisors.*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N= 15                    /*Not specified?  Then use the default.*/
say '──divisors──  ──smallest number with N divisors──' /*display title for the numbers.*/
@.=                                              /*the  @  array is used for memoization*/
    do i=1  for N;     z= 1  +  (i\==1)          /*step through a number of divisors.   */
       do j=z  by z                              /*now, search for a number that ≡ #divs*/
       if @.j==.  then iterate                   /*has this number already been found?  */
       d= #divs(j);    if d\==i  then iterate    /*get # divisors;  Is not equal?  Skip.*/
       say center(i, 12)  right(j, 19)           /*display the #divs and the smallest #.*/
       @.j= .                                    /*mark as having found #divs for this J*/
       leave                                     /*found a number, so now get the next I*/
       end   /*j*/
    end      /*i*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
#divs: procedure; parse arg x 1 y                /*X and Y:  both set from 1st argument.*/
       if x<7  then do; if x<3   then return x   /*handle special cases for one and two.*/
                        if x<5   then return x-1 /*   "      "      "    "  three & four*/
                        if x==5  then return 2   /*   "      "      "    "  five.       */
                        if x==6  then return 4   /*   "      "      "    "  six.        */
                    end
       odd= x // 2                               /*check if   X   is  odd  or not.      */
       if odd  then      #= 1                    /*Odd?   Assume  Pdivisors  count of 1.*/
               else do;  #= 3;   y= x%2;  end    /*Even?     "        "        "    " 3.*/
                                                 /* [↑]   start with known num of Pdivs.*/
                  do k=3  for x%2-3  by 1+odd  while k<y  /*for odd numbers, skip evens.*/
                  if x//k==0  then do            /*if no remainder, then found a divisor*/
                                   #=#+2;  y=x%k /*bump  #  Pdivs,  calculate limit  Y. */
                                   if k>=y  then do;  #= #-1;  leave;  end      /*limit?*/
                                   end                                          /*  ___ */
                              else if k*k>x  then leave        /*only divide up to √ x  */
                  end   /*k*/                    /* [↑]  this form of DO loop is faster.*/
       return #+1                                /*bump "proper divisors" to "divisors".*/
