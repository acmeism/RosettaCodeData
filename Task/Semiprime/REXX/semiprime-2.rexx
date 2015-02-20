/*REXX program determines if any number  (or a range)  is/are semiprime.*/
parse arg bot top .                    /*obtain #s from the command line*/
if bot==''  then bot=random()          /*so, the user wants us to guess.*/
if top==''  then top=bot               /*maybe define a range of numbers*/
w=max(length(bot), length(top))        /*get maximum width of numbers.  */
if w>digits()  then numeric digits w   /*is there enough digits ?       */
             do n=bot  to top          /*show results for a range of #s.*/
             if isSemiPrime(n)  then say right(n,w)    '    is semiprime.'
                                else say right(n,w)    " isn't semiprime."
             end   /*n*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isPrime:  procedure;   parse arg x;          if x<2  then return 0
if wordpos(x,'2 3 5 7')\==0   then return 1  /*handle some special cases*/
  do i=2  for 2;  if x//i==0  then return 0;  end  /*i*/    /*÷ by 2 & 3*/
  do j=5  by 6  until j*j>x;  if x//j==0      then return 0 /*¬ a prime#*/
                              if x//(j+2)==0  then return 0 /*¬ a prime#*/
  end   /*j*/
return 1                               /*X  is a prime number, for sure.*/
/*──────────────────────────────────ISSEMIPRIME subroutine──────────────*/
isSemiPrime: procedure;  arg x;   if \datatype(x,'W') | x<4  then return 0
x=x/1                                  /*normalize the   X   number.    */
            do i=2 for 2; if x//i==0  then  if isPrime(x%i)  then return 1
                                                             else return 0
            end     /*i*/              /* [↑]  divides by two and three.*/
  do j=5  by  6;          if j*j>x    then  return 0         /*÷ by #s. */
    do k=j  by 2  for 2;  if x//k==0  then  if isPrime(x%k)  then return 1
                                                             else return 0
    end   /*k*/                        /*see if 2nd factor is prime or ¬*/
  end     /*j*/                        /*[↑] never ÷ by # divisible by 3*/
