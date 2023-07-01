Sub Main()
    '...
    If problem Then
        For n& = Forms.Count To 0 Step -1
            Unload Forms(n&)
        Next
        Exit Sub
    End If
    '...
End Sub
