Option Explicit
Dim seed As Long
Sub Main()
    Dim i As Integer
    seed = 675248
    For i = 1 To 5
        Debug.Print Rand
    Next i
End Sub
Function Rand() As Variant
    Dim s As String
    s = CStr(seed ^ 2)
    Do While Len(s) <> 12
        s = "0" + s
    Loop
    seed = Val(Mid(s, 4, 6))
    Rand = seed
End Function
