Sub C_S_If()
Dim A$, B$

    A = "Hello"
    B = "World"
    'test
    If A = B Then Debug.Print A & " = " & B
    'other syntax
    If A = B Then
        Debug.Print A & " = " & B
    Else
        Debug.Print A & " and " & B & " are differents."
    End If
    'other syntax
    If A = B Then
        Debug.Print A & " = " & B
    Else: Debug.Print A & " and " & B & " are differents."
    End If
    'other syntax
    If A = B Then Debug.Print A & " = " & B _
    Else Debug.Print A & " and " & B & " are differents."
    'other syntax
    If A = B Then Debug.Print A & " = " & B Else Debug.Print A & " and " & B & " are differents."
    If A = B Then Debug.Print A & " = " & B Else: Debug.Print A & " and " & B & " are differents."
End Sub
