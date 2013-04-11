'stack test
Public Sub stacktest()
  Dim aStack As New Stack
  With aStack
    'push and pop some value
    .Push 45
    .Push 123.45
    .Pop
    .Push "a string"
    .Push "another string"
    .Pop
    .Push Cos(0.75)
    Debug.Print "stack size is "; .Size
    While Not .IsEmpty
      Debug.Print "pop: "; .Pop
    Wend
    Debug.Print "stack size is "; .Size
    'try to continue popping
    .Pop
  End With
End Sub
