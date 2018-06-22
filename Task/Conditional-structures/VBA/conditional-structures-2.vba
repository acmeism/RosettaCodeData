Sub C_S_ElseIf()
Dim A$, B$

    A = "Hello"
    B = "World"
    'test
    If A = B Then Debug.Print A & " = " & B
    'other syntax
    If A = B Then
        Debug.Print A & " = " & B
    ElseIf A > B Then
        Debug.Print A & " > " & B
    Else
        Debug.Print A & " < " & B
    End If
End Sub
