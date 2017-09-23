/*REXX program determines if any integer  (or a range of integers)  is/are  semiprime.  */
parse arg bot top .                              /*obtain optional arguments from the CL*/
if bot=='' | bot==","  then bot=random()         /*None given?   User wants us to guess.*/
if top=='' | top==","  then top=bot              /*maybe define a range of numbers.     */
tell=  top=>0 |  top==bot                        /*should results be shown to the term? */
w=max(length(bot), length(top)) + 5              /*obtain the maximum width of numbers. */
numeric digits max(9, w)                         /*ensure there're enough decimal digits*/
#=0                                              /*initialize number of semiprimes found*/
             do n=bot  to abs(top)               /*show results for a range of numbers. */
             ?=isSemiPrime(n);      #=#+?        /*Is N a semiprime?; Maybe bump counter*/
             if tell  then say right(n,w)  right(word("isn't" 'is', ?+1), 6)  'semiprime.'
             end   /*n*/
say
if bot\==top  then say 'found '   #   " semiprimes."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure;  parse arg x;               if x<2  then return 0  /*number too low?*/
         if wordpos(x, '2 3 5 7 11 13 17 19 23')\==0    then return 1  /*it's low prime.*/
         if x//2==0  then return 0;     if x//3==0      then return 0  /*÷ by 2; ÷ by 3?*/
           do j=5  by 6  until j*j>x;   if x//j==0      then return 0  /*not a prime.   */
                                        if x//(j+2)==0  then return 0  /* "  "   "      */
           end   /*j*/
         return 1                                /*indicate that  X  is a prime number. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isSemiPrime: procedure;  parse arg x;          if x<4  then return 0

                           do i=2  for 2;  if x//i==0  then if isPrime(x%i)  then return 1
                                                                             else return 0
                           end   /*i*/
                                                                             /*    ___  */
               do   j=5  by 6;         if j*j>x    then  return 0            /* > √ x  ?*/
                 do k=j  by 2  for 2;  if x//k==0  then  if isPrime(x%k)  then return 1
                                                                          else return 0
                 end   /*k*/                     /* [↑]  see if 2nd factor is prime or ¬*/
               end     /*j*/                     /* [↑]  J is never a multiple of three.*/
