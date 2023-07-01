/* REXX ---------------------------------------------------------------
* 01.07.2014 Walter Pachl
* Argument values must not start with 'arg'
*--------------------------------------------------------------------*/
x=f(2,3)
Say x
Say ''
y=f('arg2='3,'arg1='2)
Say y
Exit
f: Procedure
Parse Arg p1,p2
Do i=1 to arg()
  If left(arg(i),3)='arg' Then
    Parse Value arg(i) With 'arg' j '=' p.j
  Else p.i=arg(i)
  End
Do i=1 To arg()
  Say 'p.'i'='p.i
  End
Return p.1**p.2
