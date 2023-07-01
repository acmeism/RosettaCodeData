Public Function CommonDirectoryPath(ParamArray Paths()) As String
Dim v As Variant
Dim Path() As String, s As String
Dim i As Long, j As Long, k As Long
Const PATH_SEPARATOR As String = "/"

  For Each v In Paths
    ReDim Preserve Path(0 To i)
    Path(i) = v
    i = i + 1
  Next v

  k = 1

  Do
    For i = 0 To UBound(Path)
      If i Then
        If InStr(k, Path(i), PATH_SEPARATOR) <> j Then
          Exit Do
        ElseIf Left$(Path(i), j) <> Left$(Path(0), j) Then
          Exit Do
        End If
      Else
        j = InStr(k, Path(i), PATH_SEPARATOR)
        If j = 0 Then
          Exit Do
        End If
      End If
    Next i
    s = Left$(Path(0), j + CLng(k <> 1))
    k = j + 1
  Loop
  CommonDirectoryPath = s

End Function

Sub Main()

' testing the above function

Debug.Assert CommonDirectoryPath( _
 "/home/user1/tmp/coverage/test", _
 "/home/user1/tmp/covert/operator", _
 "/home/user1/tmp/coven/members") = _
 "/home/user1/tmp"

 Debug.Assert CommonDirectoryPath( _
 "/home/user1/tmp/coverage/test", _
 "/home/user1/tmp/covert/operator", _
 "/home/user1/tmp/coven/members", _
 "/home/user1/abc/coven/members") = _
 "/home/user1"

Debug.Assert CommonDirectoryPath( _
 "/home/user1/tmp/coverage/test", _
 "/hope/user1/tmp/covert/operator", _
 "/home/user1/tmp/coven/members") = _
 "/"

End Sub
