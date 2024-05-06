/*REXX program  finds and displays  the    Nth  number   with exactly   N   divisors.   */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N= 15                    /*Not specified?  Then use the default.*/
if N>=50  then numeric digits 10                 /*use more decimal digits for large N. */
w= 50                                            /*W:  width of the 2nd column of output*/
say '─divisors─'  center("the Nth number with exactly N divisors", w, '─')      /*title.*/
@.1= 2;                                   Ps= 1  /*1st prime;  number of primes (so far)*/
        do p=3  until Ps==N                      /* [↓]  gen N primes, store in @ array.*/
        if \isPrime(p)  then iterate;     Ps= Ps + 1;        @.Ps= p
        end   /*gp*/
!.=                                              /*the  !  array is used for memoization*/
        do i=1  for N;      odd= i//2            /*step through a number of divisors.   */
        if odd  then  if isPrime(i)  then do;  _= pPow();            w= max(w, length(_) )
                                               call tell  commas(_);              iterate
                                          end
        #= 0;            even= \odd              /*the number of occurrences for #div.  */
            do j=1;      jj= j                   /*now, search for a number that ≡ #divs*/
            if odd  then jj= j*j                 /*Odd and non-prime?  Calculate square.*/
            if !.jj==.  then iterate             /*has this number already been found?  */
            d= #divs(jj)                         /*get # divisors;  Is not equal?  Skip.*/
            if even  then if d<i  then do;  !.j=.;  iterate;  end   /*Too low?  Flag it.*/
            if d\==i  then iterate               /*Is not equal?  Then skip this number.*/
            #= # + 1                             /*bump number of occurrences for #div. */
            if #\==i  then iterate               /*Not correct occurrence? Keep looking.*/
            call tell  commas(jj)                /*display Nth number with #divs*/
            leave                                /*found a number, so now get the next I*/
            end   /*j*/
        end       /*i*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do j=length(_)-3  to 1  by -3; _=insert(',', _, j); end;    return _
pPow:   numeric digits 1000;  return @.i**(i-1)  /*temporarily increase decimal digits. */
tell: parse arg _; say center(i,10) right(_,max(w,length(_))); if i//5==0 then say; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
#divs: procedure; parse arg x 1 y                /*X and Y:  both set from 1st argument.*/
       if x<7  then do                           /*handle special cases for numbers < 7.*/
                    if x<3   then return x       /*   "      "      "    "  one and two.*/
                    if x<5   then return x - 1   /*   "      "      "    "  three & four*/
                    if x==5  then return 2       /*   "      "      "    "  five.       */
                    if x==6  then return 4       /*   "      "      "    "  six.        */
                    end
       odd= x // 2                               /*check if   X   is  odd  or not.      */
       if odd  then do;  #= 1;             end   /*Odd?   Assume  Pdivisors  count of 1.*/
               else do;  #= 3;    y= x%2;  end   /*Even?     "        "        "    " 3.*/
                                                 /* [↑]   start with known num of Pdivs.*/
                  do k=3  by 1+odd  while k<y    /*when doing odd numbers,  skip evens. */
                  if x//k==0  then do            /*if no remainder, then found a divisor*/
                                   #=#+2;  y=x%k /*bump  #  Pdivs,  calculate limit  Y. */
                                   if k>=y  then do;  #= #-1;  leave;  end      /*limit?*/
                                   end                                          /*  ___ */
                              else if k*k>x  then leave        /*only divide up to √ x  */
                  end   /*k*/                    /* [↑]  this form of DO loop is faster.*/
       return #+1                                /*bump "proper divisors" to "divisors".*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure; parse arg #;         if wordpos(#, '2 3 5 7 11 13')\==0  then return 1
         if #<2  then return 0;    if #//2==0 | #//3==0 | #//5==0 | #//7==0  then return 0
                                         if # // 2==0 | # // 3    ==0  then return 0
           do j=11  by 6  until j*j>#;   if # // j==0 | # // (J+2)==0  then return 0
           end   /*j*/                           /*           ___                       */
         return 1                                /*Exceeded  √ #  ?    Then # is prime. */
