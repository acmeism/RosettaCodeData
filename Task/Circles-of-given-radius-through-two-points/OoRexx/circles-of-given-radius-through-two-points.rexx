/*REXX pgm finds 2 circles with a specific radius given two (X,Y) points*/
  a.=''
  a.1=0.1234 0.9876 0.8765 0.2345 2
  a.2=0.0000 2.0000 0.0000 0.0000 1
  a.3=0.1234 0.9876 0.1234 0.9876 2
  a.4=0.1234 0.9876 0.8765 0.2345 0.5
  a.5=0.1234 0.9876 0.1234 0.9876 0

  Say '     x1      y1      x2      y2  radius   cir1x   cir1y   cir2x   cir2y'
  Say ' ------  ------  ------  ------  ------  ------  ------  ------  ------'
  Do j=1 By 1 While a.j<>''
    Do k=1 For 4
      w.k=f(word(a.j,k))
      End
    Say w.1 w.2 w.3 w.4 format(word(a.j,5),5,1)  twocircles(a.j)
    End
  Exit

twocircles: Procedure
  Parse Arg px py qx qy r .
  If r=0 Then
    Return ' radius of zero gives no circles.'
  x=(qx-px)/2
  y=(qy-py)/2
  bx=px+x
  by=py+y
  pb=rxCalcsqrt(x**2+y**2)
  If pb=0 Then
    Return ' coincident points give infinite circles'
  If pb>r Then
    Return ' points are too far apart for the given radius'
  cb=rxCalcsqrt(r**2-pb**2)
  x1=y*cb/pb
  y1=x*cb/pb
  Return f(bx-x1) f(by+y1) f(bx+x1) f(by-y1)

f: Return format(arg(1),2,4) /* format a number with 4 dec dig.*/

::requires 'rxMath' library
