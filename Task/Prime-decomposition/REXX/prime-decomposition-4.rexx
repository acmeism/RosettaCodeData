/*REXX pgm does prime decomposition of a range of positive integers (with a prime count)*/
include Settings

say version; say 'Prime decompositoion'; say
Numeric Digits 1000                   /*handle thousand digits For the powers*/
Parse Arg  bot  top  step   base  add /*get optional arguments from the C.L. */
If bot='qq' Then Do
  Say 'rexx pfoo bot  top  step   base  add'
  Exit
  End
If bot=='' Then                       /* no arguments given                  */
  Parse Value 1 100 With bot top      /* set default range                  .*/
If top=='' Then top=bot               /* process one Number                  */
If step=='' Then step=1               /* step=2 to process only Odd numbers  */
If add =='' Then add=-1               /* for Mersenne tests                  */
tell=top>0                            /*If TOP is negative, suppress displays*/
top=Abs(top)
w=Length(top)                         /*get maximum width For aligned display*/
If base\=='' Then
  w=Length(base**top)                 /*will be testing powers of two laterqq */
tag.=Left('', 7)                      /*some literals:  pad;  Prime (or not).*/
tag.0='{unity}'
tag.1='[Prime]'
Numeric Digits Max(9,w+1)             /*maybe increase the digits precision. */
np=0                                  /*np:    is the Number of Primes found.*/
Do n=bot To top by step               /*process a single Number or a range.  */
  qq=n
  If base\=='' Then                   /*should we perform a 'Mersenne' testqq */
    qq=base**n+add
  f=Factors(qq)                       /* Number of Prime Factors             */
  If f=1 Then                         /* If the Number is Prime              */
    np=np+1                           /* Then bump Prime counter             */
  If tell Then do
     pf = ''
     do i = 1 to f
        pf = pf glob.factor.i
     end
    Say Right(qq,w) Right('('f')',9) 'Prime Factors: ' tag.f pf
  end
  End   /*n*/
Say ''
ps='Prime'
If f>1 Then ps=ps's'                  /*setup For proper English in sentence.*/
Say Right(np, w+9+1) ps 'found.'      /*display the Number of Primes found.  */
say Format(Time('e'),,3) 'seconds'
Exit                                  /*stick a fork in it,  we're all done. */

Factors:
/* Prime factors of an integer */
procedure expose glob.
arg x
/* Fast values */
if x = 1 then do
   glob.factor.0 = 0
   return 0
end
if x < 4 then do
   glob.factor.1 = x; glob.factor.0 = 1
   return 1
end
if Prime(x) then do
   glob.factor.1 = x; glob.factor.0 = 1
   return 1
end
/* Check low factors */
n = 0
pr = '2 3 5 7 11 13 17 19 23'
do i = 1 to Words(pr)
   p = Word(pr,i)
   do while x//p = 0
      n = n+1; glob.factor.n = p
      x = x%p
   end
end
/* Check higher factors */
do j = 29 by 6 while j*j <= x
   p = Right(j,1)
   if p <> 5 then do
      do while x//j = 0
         n = n+1; glob.factor.n = j
         x = x%j
      end
   end
   if p = 3 then
      iterate
   y = j+2
   do while x//y = 0
      n = n+1; glob.factor.n = y
      x = x%y
   end
end
/* Last factor */
if x > 1 then  do
   n = n+1; glob.factor.n = x
end
glob.factor.0 = n
/* Return number of factors */
return n

include Functions
include Numbers
include Sequences
include Abend
