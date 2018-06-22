Sub foo1()
    err.raise(vbObjectError + 1050)
End Sub

Sub foo2()
    Error vbObjectError + 1051
End Sub
