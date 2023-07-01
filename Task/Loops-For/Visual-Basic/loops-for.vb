Public OutConsole As Scripting.TextStream
For i = 0 To 4
    For j = 0 To i
        OutConsole.Write "*"
    Next j
    OutConsole.WriteLine
Next i
