Declare Function MultiByteToWideChar Lib "kernel32.dll" ( _
     ByVal CodePage As Long, _
     ByVal dwFlags As Long, _
     ByVal lpMultiByteStr As Long, _
     ByVal cchMultiByte As Long, _
     ByVal lpWideCharStr As Long, _
     ByVal cchWideChar As Long) As Long
Const CP_UTF8 As Long = 65001

Sub Main()
Dim fn As Integer
Dim i As Long
Dim b() As Byte
Dim s As String

  fn = FreeFile()
  Open "c:\test.txt" For Binary Access Read As #fn
  ReDim b(0 To (LOF(fn) - 1))
  Get #fn, 1, b()

  If b(0) = &HFF And b(1) = &HFE Then
  'UTF-16, little-endian
    ReDim b(0 To (LOF(fn) - 3))
    Get #fn, 3, b()
    s = b()
  ElseIf b(0) = &HEF And b(1) = &HBB And b(2) = &HBF Then
  'UTF-8
    i = MultiByteToWideChar(CP_UTF8, 0&, VarPtr(b(3)), LOF(fn) - 3, StrPtr(s), 0)
    s = Space$(i)
    i = MultiByteToWideChar(CP_UTF8, 0&, VarPtr(b(3)), LOF(fn) - 3, StrPtr(s), Len(s))
  Else
  'assume ANSI
    s = StrConv(b(), vbUnicode)
  End If
  Close #fn
  Debug.Print s
End Sub
