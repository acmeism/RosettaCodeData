Option Explicit
Declare Function RtlComputeCrc32 Lib "ntdll.dll" _
  (ByVal dwInitial As Long, pData As Any, ByVal iLen As Long) As Long
'--------------------------------------------------------------------
Sub Main()
Dim s As String
Dim b() As Byte
Dim l As Long

  s = "The quick brown fox jumps over the lazy dog"
  b() = StrConv(s, vbFromUnicode) 'convert Unicode to ASCII
  l = RtlComputeCrc32(0&, b(0), Len(s))
  Debug.Assert l = &H414FA339

End Sub
