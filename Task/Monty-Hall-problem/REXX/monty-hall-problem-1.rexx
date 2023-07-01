/* REXX ***************************************************************
* 30.08.2013 Walter Pachl derived from Java
**********************************************************************/
Call time 'R'
switchWins = 0;
stayWins = 0
Do plays = 1 To 1000000
  doors.=0
  r=r3()
  doors.r=1
  choice = r3()
  Do Until shown<>choice  & doors.shown=0
    shown  = r3()
    End
  If doors.choice=1 Then
    stayWins=stayWins+1
  Else
    switchWins=switchWins+1
  End
Say "Switching wins " switchWins " times."
Say "Staying wins   " stayWins   " times."
Say 'REXX:' time('E') 'seconds'
Call time 'R'
'ziegen'
Say 'PL/I:' time('E') 'seconds'
Say ' '
Call time 'R'
'java ziegen'
Say 'NetRexx:' time('E') 'seconds'
Exit
r3: Return random(2)+1
