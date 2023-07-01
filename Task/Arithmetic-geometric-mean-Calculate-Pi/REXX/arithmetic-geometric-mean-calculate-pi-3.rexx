/*REXX*/

Do d=10 To 13
  Say d pib(d)
  End
Do d=1000 To 1005
  pi=pib(d)
  say d left(pi,5)'...'substr(pi,997)
  End
Exit
pib: Procedure
/* REXX ---------------------------------------------------------------
* program calculates the value of pi using the  AGM  algorithm.
* building on top of version 2
* reformatted, improved, and using 'my own' sqrt
* 08.07.2014 Walter Pachl
*--------------------------------------------------------------------*/
  Parse Arg d .
  If d=='' Then
    d=500                           /* D specified?  Then use default.*/
  Numeric Digits d+5                /* set the numeric digits to D+5. */
  a=1
  n=1
  z=1/4
  g=sqrt(1/2)                       /* calculate some initial values. */
  Do j=1 Until a==old
    old=a                           /* keep calculating until no noise*/
    x=(a+g)*.5
    g=sqrt(a*g)                     /* calculate the next set of terms*/
    z=z-n*(x-a)**2
    n=n+n
    a=x
    End
  pi=a**2/z
  Numeric Digits d                  /* set the  numeric digits  to  D */
  Return pi+0

sqrt: Procedure
  Parse Arg x
  xprec=digits()
  iprec=xprec+10
  Numeric Digits iprec
  r0=x
  r =1
  Do i=1 By 1 Until r=r0 | (abs(r*r-x)<10**-iprec)
    r0 = r
    r  = (r + x/r) / 2
    End
  Numeric Digits xprec
  Return (r+0)
