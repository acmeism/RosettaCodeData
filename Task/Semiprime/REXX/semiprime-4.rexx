/*REXX program determines if any integer  (or a range of integers)  is/are  semiprime.  */
/*REXX program determines if any integer  (or a range of integers)  is/are  semiprime.  */
include Settings

say version; say 'Semi Primes'; say
parse arg bot top .                              /*obtain optional arguments from the CL*/
if bot=='' | bot==","  then bot=Random()         /*None givenqq  User wants us to guess.*/
if top=='' | top==","  then top=bot              /*maybe define a range of numbers.     */
tell= (top>0)                                    /*should results be shown to the termqq */
w=Max(Length(bot), Length(top))                  /*obtain the maximum width of numbers. */
numeric digits Max(9, w)                         /*ensure there're enough decimal digits*/
hh=0                                             /*initialize Number of semiprimes found*/
             do n=Abs(bot)  to Abs(top)          /*show results for a range of numbers. */
             qq=IsSemiPrime(n);     hh=hh+qq     /*Is N a semiprimeqq; Maybe bump counter*/
if tell  then say Right(n,w)  Right(Word("isn't" 'is', qq+1), 6) 'Semiprime.' '('Format(Time('e'),,3) 'seconds)'
call Time('r')
             end   /*n*/
say
if bot\==top  then say 'found '   hh  " semiprimes."
say Format(Time('e'),,3) ' seconds'
exit                                             /*stick a fork in it,  we're all done. */

IsSemiprime:
/* Is a number semi prime? function */
procedure expose glob.
arg x
/* Low semiprimes */
s = '4 6 9 10 14 15 21 22 25 26 33 34 35 38 39 46 49 51 55 57 58 62 65 69 74 77 82 85 86 87 91 93 94 95'
/* Fast values */
if x < 101 then do
   if Wordpos(x,s) = 0 then
      return 0
   else
      return 1
end
/* Wheeled scan */
do i = 2 for 2
   if x//i = 0 then
      if Prime(x%i) then
         return 1
      else
         return 0
end
do i = 5 by 6 until i*i > x
   do j = i by 2 for 2
      if x//j==0 then
         if Prime(x%j) then
            return 1
         else
            return 0
   end
end
return 0

include Functions
include Numbers
include Abend
