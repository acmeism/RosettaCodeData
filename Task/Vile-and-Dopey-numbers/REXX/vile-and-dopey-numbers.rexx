/*REXX program to show and count Vile and Dopey numbers                                 */
v.=0
d.=0
line.=0
xl=''
Do exp=1 To 10
  xl=xl 2**exp
  End

Do i=1 To 2**10
  b=x2b(d2x(i))
  k=lastpos(1,b)
  If (length(b)-k)//2=0 Then Do
    v.0+=1
    If v.0<=25 Then Do; z=v.0; v.z=right(i,2); End
    End
  Else Do
    d.0+=1
    If d.0<=25 Then Do; z=d.0; d.z=right(i,2); End
    End

  If wordpos(i,xl)>0 Then do
    z=line.0+1
    line.z=right(i,4) right(v.0,6) right(d.0,6)
    line.0=z
    End
End
vo=''
Do i=1 To 25
  vo=vo v.i
  End
Say 'The first 25 Vile numbers:'
Say ' 'strip(vo)
do=''
Do i=1 To 25
  do=do d.i
  End
Say ''
Say 'The first 25 Dopey numbers:'
Say ' 'strip(do)
Say ''
Say 'Upto:  Vile  Dopey'
Do i=1 To line.0
  Say line.i
End
