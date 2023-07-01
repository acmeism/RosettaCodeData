Option Explicit

Public Sub AttractiveNumbers()
Dim max As Integer, i As Integer, n As Integer

max = 120

For i = 1 To max
    n = CountPrimeFactors(i)
    If IsPrime(n) Then Debug.Print i
Next i

End Sub

Public Function IsPrime(ByVal n As Integer) As Boolean
Dim d As Integer

IsPrime = True
d = 5

If n < 2 Then
    IsPrime = False
    GoTo Finish
End If

If n Mod 2 = 0 Then
    IsPrime = (n = 2)
    GoTo Finish
End If

If n Mod 3 = 0 Then
    IsPrime = (n = 3)
    GoTo Finish
End If

While (d * d <= n)
    If (n Mod d = 0) Then IsPrime = False
    d = d + 2
    If (n Mod d = 0) Then IsPrime = False
    d = d + 4
Wend
Finish:
End Function

Public Function CountPrimeFactors(ByVal n As Integer) As Integer

Dim count As Integer, f As Integer

If n = 1 Then
    CountPrimeFactors = 0
    GoTo Finish2
End If

If (IsPrime(n)) Then
    CountPrimeFactors = 1
    GoTo Finish2
End If

count = 0
f = 2

Do While (True)
    If n Mod f = 0 Then
        count = count + 1
        n = n / f
        If n = 1 Then
            CountPrimeFactors = count
            Exit Do
        End If
        If IsPrime(n) Then f = n
    ElseIf f >= 3 Then
        f = f + 2
    Else
        f = 3
    End If
Loop

Finish2:
End Function
