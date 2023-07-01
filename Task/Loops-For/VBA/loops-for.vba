Option Explicit
Sub LoopEx()
    Dim i As Long, j As Long, s As String
    For i = 1 To 5
        s = ""
        For j = 1 To i
            s = s + "*"
        Next
        Debug.Print s
    Next
End Sub
