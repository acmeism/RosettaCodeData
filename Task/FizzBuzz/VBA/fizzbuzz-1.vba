Option Explicit

Sub FizzBuzz()
Dim Tb(1 To 100) As Variant
Dim i As Integer
    For i = 1 To 100
        Tb(i) = i
        If i Mod 15 = 0 Then
            Tb(i) = "FizzBuzz"
        ElseIf i Mod 5 = 0 Then
            Tb(i) = "Buzz"
        ElseIf i Mod 3 = 0 Then
            Tb(i) = "Fizz"
        End If
    Next
    Debug.Print Join(Tb, vbCrLf)
End Sub
