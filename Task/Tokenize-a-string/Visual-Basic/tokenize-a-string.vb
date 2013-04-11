Sub Main()
    Dim parseMe As String, parsed As Variant
    parseMe = "Hello,How,Are,You,Today"

    parsed = Split(parseMe, ",")

    Dim L0 As Long, outP As String
    outP = parsed(0)
    For L0 = 1 To UBound(parsed)
        outP = outP & "." & parsed(L0)
    Next

    MsgBox outP
End Sub
