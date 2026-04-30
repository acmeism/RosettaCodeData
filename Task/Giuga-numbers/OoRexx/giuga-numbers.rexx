Numeric Digits 1000
Call time 'R'
list=''
max=100000
do n=1 To max
  If uf(n) Then
    list=list n
  End
Say 'Giuga numbers less than' max 'are:' list
Say 'This took' time('E') 'seconds'
Say 'Verifying some solutions found by C++ and others on rosettacode.org'
Call ufv(2214408306)
Call ufv(24423128562)
Call ufv(432749205173838)
Call ufv(14737133470010574)
Call ufv(550843391309130318)
Call ufv(244197000982499715087866346)
Say 'Module sequence returns all 12 numbers listed in the'
Say 'On-Line_Encyclopedia_of_Integer_Sequences:'
n=giugas(1e39)
Do i=1 To n
  Say getst('GIUG.',i)
  End
Exit
uf: Procedure Expose UFAC.
  Parse Arg n
  nn=ufactors(n)
  If nn>1 Then Do
    do i=1 To nn
      f=getst('UFAC.',i)
      If (n/f-1)//f<>0 Then leave
      End
    if i> nn Then
      Return 1
    End
  Return 0

ufv: Procedure
  Parse Arg n
  Call time 'R'
  If uf(n) Then
    Say n 'is a Giuga number' time('E') 'seconds'
  Return

::requires math
