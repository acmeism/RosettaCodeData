'the function
Sub whatever(foo As Long, bar As Integer, baz As Byte, qux As String)
    '...
End Sub
'calling the function -- note the Pascal-style assignment operator
Sub crap()
    whatever bar:=1, baz:=2, foo:=-1, qux:="Why is ev'rybody always pickin' on me?"
End Sub
