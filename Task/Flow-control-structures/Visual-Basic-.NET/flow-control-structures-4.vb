Sub Foo1()
    If Not WorkNeeded() Then Exit Sub
    DoWork()
End Sub

Sub Foo2()
    If Not WorkNeeded() Then Return
    DoWork()
End Sub
