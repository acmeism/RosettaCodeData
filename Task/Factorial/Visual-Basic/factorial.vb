Option Explicit

Sub Main()
    Dim i As Variant
    For i = 1 To 27
        Debug.Print "Factorial(" & i & ")= , recursive : " & Format$(FactRec(i), "#,###") & " - iterative : " & Format$(FactIter(i), "#,####")
    Next
End Sub 'Main

Private Function FactRec(n As Variant) As Variant
    n = CDec(n)
    If n = 1 Then
        FactRec = 1#
    Else
        FactRec = n * FactRec(n - 1)
    End If
End Function 'FactRec

Private Function FactIter(n As Variant)
    Dim i As Variant, f As Variant
    f = 1#
    For i = 1# To CDec(n)
        f = f * i
    Next i
    FactIter = f
End Function 'FactIter
