Public Sub backup(filename As String)
    If Len(Dir(filename)) > 0 Then
        On Error Resume Next
        Name filename As filename & ".bak"
    Else
        If Len(Dir(filename & ".lnk")) > 0 Then
            On Error Resume Next
            With CreateObject("Wscript.Shell").CreateShortcut(filename & ".lnk")
                link = .TargetPath
                .Close
            End With
            Name link As link & ".bak"
        End If
    End If
End Sub
Public Sub main()
    backup "D:\test.txt"
End Sub
