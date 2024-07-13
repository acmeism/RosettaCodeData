/*REXX pgm does prime decomposition of a range of positive integers (with a prime count)*/
call time('r')
Numeric Digits 1000                   /*handle thousand digits For the powers*/
Parse Arg  bot  top  step   base  add /*get optional arguments from the C.L. */
If bot='?' Then Do
  Say 'rexx pfoo bot  top  step   base  add'
  Exit
  End
If bot=='' Then                       /* no arguments given                  */
  Parse Value 1 100 With bot top      /* set default range                  .*/
If top=='' Then top=bot               /* process one number                  */
If step=='' Then step=1               /* step=2 to process only odd numbers  */
If add =='' Then add=-1               /* for Mersenne tests                  */
tell=top>0                            /*If TOP is negative, suppress displays*/
top=abs(top)
w=length(top)                         /*get maximum width For aligned display*/
If base\=='' Then
  w=length(base**top)                 /*will be testing powers of two later? */
tag.=left('', 7)                      /*some literals:  pad;  prime (or not).*/
tag.0='{unity}'
tag.1='[prime]'
Numeric Digits max(9,w+1)             /*maybe increase the digits precision. */
np=0                                  /*np:    is the number of primes found.*/
Do n=bot To top by step               /*process a single number or a range.  */
  ?=n
  If base\=='' Then                   /*should we perform a 'Mersenne' test? */
    ?=base**n+add
  pf=factr(?)                         /* get prime factors                   */
  f=words(pf)                         /* number of prime factors             */
  If f=1 Then                         /* If the number is prime              */
    np=np+1                           /* Then bump prime counter             */
  If tell Then
    Say right(?,w) right('('f')',9) 'prime factors: ' tag.f pf
  End   /*n*/
Say ''
ps='prime'
If f>1 Then ps=ps's'                  /*setup For proper English in sentence.*/
Say right(np, w+9+1) ps 'found.'      /*display the number of primes found.  */
say format(time('e'),,3) 'seconds'
Exit                                  /*stick a fork in it,  we're all done. */
/*---------------------------------------------------------------------------*/
Factr:
procedure expose glob.
arg x
primes = '2 3 5 7 11 13 17 19 23'; pl = ''
do n = 1 to words(primes)
   prime = word(primes,n)
   do while x//prime = 0
      pl = pl prime; x = x%prime
   end
end
do j = 29 by 6 while j*j <= x
   d = right(j,1)
   if d <> 5 then do
      do while x//j = 0
         pl = pl j; x = x%j
      end
   end
   if d = 3 then
      iterate
   y = j+2
   do while x//y = 0
      pl = pl y; x = x%y
   end
end
if x = 1 then
   return pl
else
   return pl x
