/* REXX */
Parse Version v
Say v
Call Time 'R'
z=1
p.0=3
p.1=2
p.2=3
p.3=5
Do n=5 By 2 Until z=10001
  If right(n,1)=5 Then Iterate
  Do i=2 To p.0 Until b**2>n
    b=p.i
    If n//b=0 Then Leave
    End
  If b**2>n Then Do
    z=p.0+1
    p.z=n
    p.0=z
    End
  End
Say z n time('E')
