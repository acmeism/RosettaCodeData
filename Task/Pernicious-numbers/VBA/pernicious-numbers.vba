Private Function population_count(ByVal number As Long) As Integer
    Dim result As Integer
    Dim digit As Integer
    Do While number > 0
        If number Mod 2 = 1 Then
            result = result + 1
        End If
        number = number \ 2
    Loop
    population_count = result
End Function

Function is_prime(n As Integer) As Boolean
    If n < 2 Then
        is_prime = False
        Exit Function
    End If
    For i = 2 To Sqr(n)
        If n Mod i = 0 Then
            is_prime = False
            Exit Function
        End If
    Next i
    is_prime = True
End Function

Function pernicious(n As Long)
    Dim tmp As Integer
    tmp = population_count(n)
    pernicious = is_prime(tmp)
End Function

Public Sub main()
    Dim count As Integer
    Dim n As Long: n = 1
    Do While count < 25
        If pernicious(n) Then
            Debug.Print n;
            count = count + 1
        End If
        n = n + 1
    Loop
    Debug.Print
    For n = 888888877 To 888888888
        If pernicious(n) Then
            Debug.Print n;
        End If
    Next n
End Sub
