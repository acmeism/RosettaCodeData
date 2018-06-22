Sub String_Comparison_FirstWay()
Dim A$, B$, C$

    If A = B Then Debug.Print "A = B"

    A = "creation": B = "destruction": C = "CREATION"

    'test equality : (operator =)
    If A = B Then
         Debug.Print A & " = " & B
    'used to Sort : (operator < and >)
    ElseIf A > B Then
         Debug.Print A & " > " & B
    Else 'here : A < B
         Debug.Print A & " < " & B
    End If

    'test if A is different from C
    If A <> C Then Debug.Print A & " and " & B & " are differents."
    'same test without case-sensitive
    If UCase(A) = UCase(C) Then Debug.Print A & " = " & C & " (no case-sensitive)"

    'operator Like :
    If A Like "*ation" Then Debug.Print A & " Like *ation"
    If Not B Like "*ation" Then Debug.Print B & " Not Like *ation"
    'See Also :
'https://docs.microsoft.com/en-us/dotnet/visual-basic/language-reference/operators/like-operator
End Sub
