/*REXX program determines if any integer  (or a range of integers)  is/are  semiprime.  */
parse arg bot top .                              /*obtain optional arguments from the CL*/
if bot=='' | bot==","  then bot=random()         /*None given?   User wants us to guess.*/
if top=='' | top==","  then top=bot              /*maybe define a range of numbers.     */
tell= bot=>0  &  top=>0                          /*should results be shown to the term? */
w=max(length(bot), length(top))                  /*obtain the maximum width of numbers. */
!.=;  !.2=1; !.3=1; !.5=1; !.7=1; !.11=1; !.13=1; !.17=1; !.19=1; !.23=1; !.29=1;  !.31=1
numeric digits max(9, w)                         /*ensure there're enough decimal digits*/
#=0                                              /*initialize number of semiprimes found*/
             do n=abs(bot)  to abs(top)          /*show results for a range of numbers. */
             ?=isSemiPrime(n);      #=#+?        /*Is N a semiprime?; Maybe bump counter*/
             if tell  then say right(n,w)  right(word("isn't" 'is', ?+1), 6)  'semiprime.'
             end   /*n*/
say
if bot\==top  then say 'found '   #   " semiprimes."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure expose !.;  parse arg x;     if x<2  then return 0  /*number too low?*/
         if !.x==1                                      then return 1  /*a known prime. */
         if x// 2==0  then return 0;    if x//3==0      then return 0  /*÷ by  2;÷by  3?*/
         parse var x '' -1 _;           if _==5         then return 0  /*last digit a 5?*/
         if x// 7==0  then return 0;    if x//11==0     then return 0  /*÷ by  7;÷by 11?*/
         if x//13==0  then return 0;    if x//17==0     then return 0  /*÷ by 13;÷by 17?*/
         if x//19==0  then return 0;    if x//23==0     then return 0  /*÷ by 19;÷by 23?*/
           do j=29  by 6  until j*j>x;  if x//j==0      then return 0  /*not a prime.   */
                                        if x//(j+2)==0  then return 0  /* "  "   "      */
           end   /*j*/
         !.x=1;                return 1          /*indicate that  X  is a prime number. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isSemiPrime: procedure expose !.;  parse arg x;          if x<4  then return 0

                           do i=2  for 2;  if x//i==0  then if isPrime(x%i)  then return 1
                                                                             else return 0
                           end   /*i*/
                                                                             /*    ___  */
               do   j=5  by 6  until j*j>x                                   /* > √ x  ?*/
                 do k=j  by 2  for 2;  if x//k==0  then  if isPrime(x%k)  then return 1
                                                                          else return 0
                 end   /*k*/                     /* [↑]  see if 2nd factor is prime or ¬*/
               end     /*j*/                     /* [↑]  J is never a multiple of three.*/
         return 0
