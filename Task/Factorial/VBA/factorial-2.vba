Option Explicit

Sub Main()
Dim i As Integer
For i = 1 To 17
    Debug.Print "Factorial " & i & " , recursive : " & FactRec(i) & ", iterative : " & FactIter(i)
Next
Debug.Print "Factorial 120, recursive : " & FactRec(120) & ", iterative : " & FactIter(120)
End Sub

Private Function FactRec(Nb As Integer) As String
If Nb > 170 Or Nb < 0 Then FactRec = 0: Exit Function
    If Nb = 1 Or Nb = 0 Then
        FactRec = 1
    Else
        FactRec = Nb * FactRec(Nb - 1)
    End If
End Function

Private Function FactIter(Nb As Integer)
If Nb > 170 Or Nb < 0 Then FactIter = 0: Exit Function
Dim i As Integer, F
    F = 1
    For i = 1 To Nb
        F = F * i
    Next i
    FactIter = F
End Function
