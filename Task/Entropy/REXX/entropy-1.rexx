/* REXX ***************************************************************
* 28.02.2013 Walter Pachl
* 12.03.2013 Walter Pachl  typo in log corrected. thanx for testing
* 22.05.2013 -"- extended the logic to accept other strings
* 25.05.2013 -"- 'my' log routine is apparently incorrect
* 25.05.2013 -"- problem identified & corrected
**********************************************************************/
Numeric Digits 30
Parse Arg s
If s='' Then
  s="1223334444"
occ.=0
chars=''
n=0
cn=0
Do i=1 To length(s)
  c=substr(s,i,1)
  If pos(c,chars)=0 Then Do
    cn=cn+1
    chars=chars||c
    End
  occ.c=occ.c+1
  n=n+1
  End
do ci=1 To cn
  c=substr(chars,ci,1)
  p.c=occ.c/n
  /* say c p.c */
  End
e=0
Do ci=1 To cn
  c=substr(chars,ci,1)
  e=e+p.c*log(p.c,30,2)
  End
Say 'Version 1:' s 'Entropy' format(-e,,12)
Exit

log: Procedure
/***********************************************************************
* Return log(x) -- with specified precision and a specified base
* Three different series are used for the ranges  0 to 0.5
*                                                 0.5 to 1.5
*                                                 1.5 to infinity
* 03.09.1992 Walter Pachl
* 25.05.2013 -"- 'my' log routine is apparently incorrect
* 25.05.2013 -"- problem identified & corrected
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
    r=r/log(b,prec)
  Numeric Digits (prec)
  r=r+0
  Return r
