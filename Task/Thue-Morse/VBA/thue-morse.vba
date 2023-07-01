Option Explicit

Sub Main()
Dim i&, t$
    For i = 1 To 8
        t = Thue_Morse(t)
        Debug.Print i & ":=> " & t
    Next
End Sub

Private Function Thue_Morse(s As String) As String
Dim k$
    If s = "" Then
        k = "0"
    Else
        k = s
        k = Replace(k, "1", "2")
        k = Replace(k, "0", "1")
        k = Replace(k, "2", "0")
    End If
    Thue_Morse = s & k
End Function
