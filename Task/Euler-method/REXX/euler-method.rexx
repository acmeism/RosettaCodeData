/* REXX ***************************************************************
* 24.05.2013 Walter Pachl  translated from PL/I
**********************************************************************/
  Numeric Digits 100
  T0=100
  Tr=20
  k=0.07

  h=2
  x=t0
  Call head
  do t=0 to 100 by 2
    Select
      When t<=4 | t>=96 Then
        call o x
      When t=8 Then
        Say '...'
      Otherwise
        Nop
      End
    x=x+h*f(x)
    end

  h=5
  y=t0
  Call head
  do t=0 to 100 by 5
    call o y
    y=y+h*f(y)
    end

  h=10
  z=t0
  Call head
  do t=0 to 100 by 10
    call o z
    z=z+h*f(z)
    end
  Exit

f: procedure Expose k Tr
  Parse Arg t
  return -k*(T-Tr)

head:
  Say 'h='h
  Say '  t    By formula       By Euler'
  Return

o:
  Parse Arg v
  Say right(t,3) format(Tr+(T0-Tr)/exp(k*t),5,10) format(v,5,10)
  Return

exp: Procedure
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
  r=r+0
  Return r
