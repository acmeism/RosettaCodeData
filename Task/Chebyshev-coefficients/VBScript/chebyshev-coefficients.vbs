' N Chebyshev coefficients for the range 0 to 1
  Dim coef(10),cheby(10)
  pi=4*Atn(1)
  a=0: b=1: n=10
  For i=0 To n-1
    coef(i)=Cos(Cos(pi/n*(i+1/2))*(b-a)/2+(b+a)/2)
  Next
  For i=0 To n-1
    w=0
    For j=0 To n-1
      w=w+coef(j)*Cos(pi/n*i*(j+1/2))
    Next
    cheby(i)=w*2/n
    If cheby(i)<=0 Then t="" Else t=" "
    WScript.StdOut.WriteLine i&" : "&t&cheby(i)
  Next
