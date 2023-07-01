/* REXX */
Numeric Digits 20
Call random(,12345) /* make the run reproducable */
pList = '.1 .3 .5 .7 .9'
nList = '1e2 1e3 1e4 1e5'
t     = 100
Do While plist<>''
  Parse Var plist p plist
  theory=p*(1-p)
  Say ' '
  Say 'p:' format(p,2,4)'  theory:'format(theory,2,4)'  t:'format(t,4)
  Say '         n          sim     sim-theory'
  nl=nlist
  Do While nl<>''
    Parse Var nl n nl
    sum=0
    Do i=1 To t
      run=0
      Do j=1 To n
        one=random(1000)<p*1000
        If one & (run=0) Then
          sum=sum+1
        run=one
        End
      End
    sim=sum/(n*100)
    Say format(n,10)'        ' format(sim,2,4)' 'format(sim-theory,2,6)
    End
  End
