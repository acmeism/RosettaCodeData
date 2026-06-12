/* REXX */
n=25
Do i=0 To n
  a.i=i
  b.i=i
  End
Call show ' pre'
Do i=n to 1 By -1
  j=random(0,i-1)
  Parse Value a.i a.j With a.j a.i
  End
Call show 'post'
Do i=0 To n
  If a.i=b.i Then
    Say i a.i '=' b.i
  End
Exit
Show:
ol=arg(1)
Do i=0 To n
  ol=ol right(a.i,2)
  End
Say ol
Return
