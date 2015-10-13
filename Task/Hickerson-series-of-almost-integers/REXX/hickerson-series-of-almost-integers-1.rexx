/* REXX ---------------------------------------------------------------
* 04.01.2014 Walter Pachl - using a rather aged ln function of mine
*                           with probably unreasonably high precision
* 05.01.2014 added n=18
*--------------------------------------------------------------------*/
Numeric Digits 100
Do n=1 To 18
  x=format(def(),20,10)
  Parse Var x '.' +1 d +1
  If pos(d,'09')>0 Then
    tag='almost an integer'
  Else
    tag=''
  Say right(n,2) x tag
  End
Exit

def:
 x=fact(n)/(2*ln(2,200)**(n + 1))
 Return x

ln: Procedure
/***********************************************************************
* Return ln(x) -- with specified precision
* Three different series are used for the ranges  0 to 0.5
*                                                 0.5 to 1.5
*                                                 1.5 to infinity
* 920903 Walter Pachl
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
    r=r/ln(b)
  Numeric Digits (prec)
  Return r+0

fact: Procedure
 Parse Arg m
 fact=1
 Do i=2 To m
   fact=fact*i
   End
 Return fact
