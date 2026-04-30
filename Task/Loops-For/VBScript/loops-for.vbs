Option Explicit
Dim i, j, s
For i = 1 To 5
    s = ""
    For j = 1 To i
        s = s + "*"
    Next
    WScript.Echo s
Next
