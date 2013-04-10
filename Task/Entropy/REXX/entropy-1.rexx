/* Rexx ***************************************************************
* 28.02.2013 Walter Pachl
* 12.03.2013 Walter Pachl  typo in log corrected. thanx for testing
**********************************************************************/
s="1223334444"
occ.=0
n=0
Do i=1 To length(s)
  c=substr(s,i,1)
  occ.c=occ.c+1
  n=n+1
  End
do c=1 To 4
  p.c=occ.c/n
  say c p.c
  End
e=0
Do c=1 To 4
  e=e+p.c*log(p.c,,2)
  End
Say 'Entropy of' s 'is' (-e)
Exit

log: Procedure
/***********************************************************************
* Return log(x) -- with specified precision and a specified base
* Three different series are used for the ranges  0 to 0.5
*                                                 0.5 to 1.5
*                                                 1.5 to infinity
* 03.09.1992 Walter Pachl
***********************************************************************/
  Parse Arg x,prec,b
  If prec='' Then prec=9
  Numeric Digits (2*prec)
  Numeric Fuzz   3
  Select
    When x<=0 Then r='*** invalid argument ***'
    When x<0.5 Then Do
      z=(x-1)/(x+1)
      o=z
      r=z
      k=1
      Do i=3 By 2
        ra=r
        k=k+1
        o=o*z*z
        r=r+o/i
        If r=ra Then Leave
        End
      r=2*r
      End
    When x<1.5 Then Do
      z=(x-1)
      o=z
      r=z
      k=1
      Do i=2 By 1
        ra=r
        k=k+1
        o=-o*z
        r=r+o/i
        If r=ra Then Leave
        End
      End
    Otherwise /* 1.5<=x */ Do
      z=(x+1)/(x-1)
      o=1/z
      r=o
      k=1
      Do i=3 By 2
        ra=r
        k=k+1
        o=o/(z*z)
        r=r+o/i
        If r=ra Then Leave
        End
      r=2*r
      End
    End
  If b<>'' Then
    r=r/log(b)
  Numeric Digits (prec)
  r=r+0
  Return r
