/*REXX program determines if any number  (or a range)  is/are  semiprime.     */
parse arg bot top .                    /*obtain optional numbers from the C.L.*/
if bot==''|bot==","  then bot=random() /*None given?   User wants us to guess.*/
if top==''|top==","  then top=bot      /*maybe define a range of numbers.     */
w=max(length(bot), length(top))        /*obtain the maximum width of numbers. */
numeric digits max(9,w)                /*ensure there're enough decimal digits*/
             do n=bot  to top          /*show results for a range of numbers. */
             if isSemiPrime(n)  then say right(n,w)      "    is semiprime."
                                else say right(n,w)      " isn't semiprime."
             end   /*n*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure;  parse arg x;     if x<2  then return 0   /*number too low*/
if wordpos(x, '2 3 5 7 11 13 17 19 23')\==0   then return 1   /*it's low prime*/
if x//2==0  then return 0;    if x//3==0      then return 0   /*÷ by 2;÷ by 3?*/
  do j=5  by 6  until j*j>x;  if x//j==0      then return 0   /*not a prime.  */
                              if x//(j+2)==0  then return 0   /* "  "   "     */
  end   /*j*/
return 1                               /*indicate that  X  is a prime number. */
/*────────────────────────────────────────────────────────────────────────────*/
isSemiPrime: procedure;  parse arg x;   if \datatype(x,'W') | x<4  then return 0
x=x/1
                  do i=2 for 2; if x//i==0  then  if isPrime(x%i)  then return 1
                                                                   else return 0
                  end   /*i*/
                                                                   /*    ___  */
  do   j=5  by 6;         if j*j>x    then  return 0               /* > √ x ? */
    do k=j  by 2  for 2;  if x//k==0  then  if isPrime(x%k)  then return 1
                                                             else return 0
    end   /*k*/                        /* [↑]  see if 2nd factor is prime or ¬*/
  end     /*j*/                        /* [↑]  never ÷ by J if J is mult. of 3*/
