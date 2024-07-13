/*REXX pgm does prime decomposition of a range of positive integers (with a prime count)*/
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
Exit                                  /*stick a fork in it,  we're all done. */
/*---------------------------------------------------------------------------*/
factr: Procedure
  Parse Arg x 1 d,pl                  /*set X, D  to argument 1, pl to null  */
  If x==1 Then Return ''              /*handle the special case of   X=1.    */
  primes=2 3 5 7
  Do While primes>''                  /* first check the small primes        */
    Parse Var primes prime primes
    Do While x//prime==0
      pl=pl prime
      x=x%prime
      End
    End
  r=isqrt(x)
  Do j=11 by 6 To r                   /*insure that J isn't divisible by 3.  */
    Parse var j '' -1 _               /*obtain the last decimal digit of  J. */
    If _\==5 Then Do
      Do While x//j==0
        pl=pl j
        x=x%j
        End                           /*maybe reduce by J.                   */
      End
    If _ ==3 Then Iterate             /*If next Y is divisible by 5?  Skip. */
    y=j+2
    Do While x//y==0
      pl=pl y
      x=x%y
      End                             /*maybe reduce by y.                   */
    End   /*j*/

  If x==1 Then Return pl              /*Is residual=unity? Then don't append.*/
               Return pl x            /*return   pl   with appended residual.*/

isqrt: Procedure
  Parse Arg x
  x=abs(x)
  Parse Value 0 x with lo hi
  Do While lo<=hi
    t=(lo+hi)%2
    If t**2>x Then
      hi=t-1
    Else
      lo=t+1
    End
  Return t
