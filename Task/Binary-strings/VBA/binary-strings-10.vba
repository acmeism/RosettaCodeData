Sub Join_Strings()
Dim A$, B As String

    A = "Hello"
    B = "world"
    Debug.Print A & " " & B         'return : Hello world
    'If you're sure that A and B are Strings, you can use + instead of & :
    Debug.Print A + " " + B         'return : Hello world
End Sub
