Option Explicit
'-----------------------------------------------------------------
Function ExtractFileExtension(ByVal Filename As String) As String
Dim i As Long
Dim s As String
  i = InStrRev(Filename, ".")
  If i Then
    If i < Len(Filename) Then
      s = Mid$(Filename, i)
      For i = 2 To Len(s)
        Select Case Mid$(s, i, 1)
        Case "A" To "Z", "a" To "z", "0" To "9"
            'these characters are OK in an extension; continue
        Case Else
            'this one is not OK in an extension
            Exit Function
        End Select
      Next i
      ExtractFileExtension = s
    End If
  End If
End Function
'-----------------------------------------------------------------
Sub Main()
Dim s As String
  s = "http://example.com/download.tar.gz"
  Debug.Assert ExtractFileExtension(s) = ".gz"
  s = "CharacterModel.3DS"
  Debug.Assert ExtractFileExtension(s) = ".3DS"
  s = ".desktop"
  Debug.Assert ExtractFileExtension(s) = ".desktop"
  s = "document"
  Debug.Assert ExtractFileExtension(s) = ""
  s = "document.txt_backup"
  Debug.Assert ExtractFileExtension(s) = ""
  s = "/etc/pam.d/login"
  Debug.Assert ExtractFileExtension(s) = ""
  s = "desktop."
  Debug.Assert ExtractFileExtension(s) = ""
  s = "a.~.c"
  Debug.Assert ExtractFileExtension(s) = ".c"
  s = "a.b.~"
  Debug.Assert ExtractFileExtension(s) = ""
  s = "a.b.1~2"
  Debug.Assert ExtractFileExtension(s) = ""
End Sub
