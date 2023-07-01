/*REXX program calculates the totient numbers for a range of numbers, and count primes. */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N==''  |  N==","  then N= 25                  /*Not specified?  Then use the default.*/
tell= N>0                                        /*N positive>?  Then display them all. */
N= abs(N)                                        /*use the absolute value of N for loop.*/
w= length(N)                                     /*W:  is used in aligning the output.  */
primes= 0                                        /*the number of primes found  (so far).*/
                                                 /*if N was negative, only count primes.*/
    do j=1  for  N;              T= phi(j)       /*obtain totient number for a number.  */
    prime= word('(prime)', 1 +  (T \== j-1 ) )   /*determine if  J  is a prime number.  */
    if prime\==''  then primes= primes + 1       /*if a prime, then bump the prime count*/
    if tell  then say 'totient number for '  right(j, w)  " ──► "  right(T, w)  ' '  prime
    end   /*j*/
say
say right(primes, w)      ' primes detected for numbers up to and including '        N
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
phi: procedure; parse arg z;                       if z==1  then return 1
     #= 1
                            do m=2  for z-2;       parse value     m   z    with    x  y
                                do until y==0;     parse value   x//y  y    with    y  x
                                end   /*until*/
                            if x==1  then #= # + 1
                            end       /*m*/
     return #
