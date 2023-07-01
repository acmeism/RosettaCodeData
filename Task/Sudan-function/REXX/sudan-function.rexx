/* REXX implement the SUDAN function */
Say '+---++-------------------------+'
Say '| y ||x= 0   1   2   3   4   5 |'
Say '+===++=========================+'
Do y=0 To 6
  s='|' y '||'
  Do x=0 To 5
    s=s format(sudan(x,y),3)
    End
  Say s '|'
  End
Say '+===++=========================+'
Exit

sudan: Procedure
  Parse Arg x,y
  Return sudan1(1,x,y)

sudan1: Procedure
  Parse Arg n,x,y
  Select
    When n=0 Then Return x+y
    When y=0 Then Return x
    Otherwise Return sudan1(n-1,sudan1(n,x,y-1),sudan1(n,x,y-1)+y)
    End
