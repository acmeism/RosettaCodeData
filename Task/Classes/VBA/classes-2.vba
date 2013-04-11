Public Sub foodemo()
'declare and create separately
Dim f As Foo
Dim f0 As Foo

Set f = New Foo

'set property
f.Bar = 25
'call method
f.DoubleBar
'alternative
Call f.DoubleBar
Debug.Print "f.Bar is "; f.Bar
Debug.Print "Five times f.Bar is "; f.MultiplyBar(5)

'declare and create at the same time
Dim f2 As New Foo
Debug.Print "f2.Bar is "; f2.Bar 'prints default value

'destroy an object
Set f = Nothing

'create an object or not, depending on a random number:
If Rnd() < 0.5 Then
  Set f0 = New Foo
End If
'check if object actually exists
If f0 Is Nothing Then
  Debug.Print "object f0 does not exist"
Else
  Debug.Print "object f0 was created"
End If
'at the end of execution all remaining objects created in this sub will be released.
'this will trigger one or two "object destroyed" messages
'depending on whether f0 was created...
End Sub
