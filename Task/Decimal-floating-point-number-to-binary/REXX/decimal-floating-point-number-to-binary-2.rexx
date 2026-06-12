/* REXX ---------------------------------------------------------------
* 08.02.2014 Walter Pachl
*--------------------------------------------------------------------*/
Call df2bf 23.34375,10111.01011
Call bf2df 1011.11101,11.90625
Call df2bf -23.34375,-10111.01011
Call bf2df -1011.11101,-11.90625
Exit

bf2df: Procedure
  Parse Arg x,soll
  If left(x,1)='-' Then Do
    sign='-'
    x=substr(x,2)
    End
  Else sign=''
  Parse Var x int '.' fract
  int=reverse(int)
  vb=1
  res=0
  Do while int<>''
    Parse Var int d +1 int
    res=res+d*vb
    vb=vb*2
    End
  vb=1
  Do while fract<>''
    vb=vb/2
    Parse Var fract d +1 fract
    res=res+d*vb
    End
  res=sign||res
  Say sign||x '->' res
  If res<>soll Then
    Say 'soll='soll
  Return

df2bf: Procedure
  Parse Arg x,soll
  If left(x,1)='-' Then Do
    sign='-'
    x=substr(x,2)
    End
  Else sign=''
  res=''
  Parse Var x int '.' +0 fract
  Do While int>0
    dig=int//2
    int=int%2
    res=dig||res
    End
  If res='' Then res='0'
  vb=1
  bf=''
  Do i=1 To 30 while fract>0
    vb=vb/2
    If fract>=vb Then Do
      bf=bf'1'
      fract=fract-vb
      End
    Else
      bf=bf'0'
    End
  res=sign||res'.'bf
  Say sign||x '->' res
  If res<>soll Then
    Say 'soll='soll
  Return
