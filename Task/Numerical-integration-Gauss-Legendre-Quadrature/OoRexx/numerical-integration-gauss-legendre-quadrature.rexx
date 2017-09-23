/*---------------------------------------------------------------------
* 31.10.2013 Walter Pachl  Translation from REXX (from PL/I)
*                          using ooRexx' rxmath package
*                          which limits the precision to 16 digits
*--------------------------------------------------------------------*/
prec=60
Numeric Digits prec
epsilon=1/10**prec
pi=3.141592653589793238462643383279502884197169399375105820974944592307
exact = RxCalcExp(3,prec)-RxCalcExp(-3,prec)
Do n = 1 To 20
  a = -3; b = 3
  r.=0
  call gaussquad
  sum=0
  Do j=1 To n
    sum=sum + r.2.j * RxCalcExp((a+b)/2+r.1.j*(b-a)/2,prec)
    End
  z = (b-a)/2 * sum
  Say right(n,2) format(z,2,40) format(z-exact,2,4,,0)
  End
  Say  '  ' exact '(exact)'
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
     x = RxCalcCos(pi*(i-0.25)/(n+0.5),prec,'R')
     Do iter = 1 To 10
       f = p1.1; df = 0
       Do k = 2 To p1.0
         df = f + x*df
         f  = p1.k + x * f
         End
       dx =  f / df
       x = x - dx
       If abs(dx) < epsilon Then Leave
       End
     r.1.i = x
     r.2.i = 2/((1-x**2)*df**2)
     End
   Return

::requires 'rxmath' LIBRARY
