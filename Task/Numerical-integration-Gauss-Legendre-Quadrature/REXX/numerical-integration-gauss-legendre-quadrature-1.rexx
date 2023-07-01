/*---------------------------------------------------------------------
* 31.10.2013 Walter Pachl  Translation from PL/I
* 01.11.2014 -"- see Version 2 for improvements
*--------------------------------------------------------------------*/
Call time 'R'
prec=60
Numeric Digits prec
epsilon=1/10**prec
pi=3.141592653589793238462643383279502884197169399375105820974944592307
exact = exp(3,prec)-exp(-3,prec)
Do n = 1 To 20
  a = -3; b = 3
  r.=0
  call gaussquad
  sum=0
  Do j=1 To n
    sum=sum + r.2.j * exp((a+b)/2+r.1.j*(b-a)/2,prec)
    End
  z = (b-a)/2 * sum
  Say right(n,2) format(z,2,40) format(z-exact,2,4,,0)
  End
  Say  '  ' exact '(exact)'
  say '... and took' format(time('E'),,2) "seconds"
  Exit

 gaussquad:
   p0.0=1; p0.1=1
   p1.0=2; p1.1=1; p1.2=0
   Do k = 2 To n
     tmp.0=p1.0+1
      Do L = 1 To p1.0
        tmp.l = p1.l
        End
      tmp.l=0
      tmp2.0=p0.0+2
      tmp2.1=0
      tmp2.2=0
      Do L = 1 To p0.0
        l2=l+2
        tmp2.l2=p0.l
        End
      Do j=1 To tmp.0
        tmp.j = ((2*k-1)*tmp.j - (k-1)*tmp2.j)/k
        End
      p0.0=p1.0
      Do j=1 To p0.0
        p0.j = p1.j
        End
      p1.0=tmp.0
      Do j=1 To p1.0
        p1.j=tmp.j
        End
   End
   Do i = 1 To n
     x = cos(pi*(i-0.25)/(n+0.5),prec)
     Do iter = 1 To 10
       f = p1.1; df = 0
       Do k = 2 To p1.0
         df = f + x*df
         f  = p1.k + x * f
         End
       dx =  f / df
       x = x - dx
       If abs(dx) < epsilon then leave
       End
     r.1.i = x
     r.2.i = 2/((1-x**2)*df**2)
     End
   Return

cos: Procedure
/* REXX ****************************************************************
* Return cos(x) -- with specified precision
* cos(x) = 1-(x**2/2!)+(x**4/4!)-(x**6/6!)+-...
* 920903 Walter Pachl
***********************************************************************/
  Parse Arg x,prec
  If prec='' Then prec=9
  Numeric Digits (2*prec)
  Numeric Fuzz 3
  o=1
  u=1
  r=1
  Do i=1 By 2
    ra=r
    o=-o*x*x
    u=u*i*(i+1)
    r=r+(o/u)
    If r=ra Then Leave
    End
  Numeric Digits prec
  Return r+0

exp: Procedure
/***********************************************************************
* Return exp(x) -- with reasonable precision
* 920903 Walter Pachl
***********************************************************************/
  Parse Arg x,prec
  If prec<9 Then prec=9
  Numeric Digits (2*prec)
  Numeric Fuzz   3
  o=1
  u=1
  r=1
  Do i=1 By 1
    ra=r
    o=o*x
    u=u*i
    r=r+(o/u)
    If r=ra Then Leave
    End
  Numeric Digits (prec)
  Return r+0
