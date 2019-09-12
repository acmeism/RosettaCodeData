Option Explicit

Private Declare Function GetComputerName Lib "kernel32.dll" Alias "GetComputerNameW" _
  (ByVal lpBuffer As Long, ByRef nSize As Long) As Long

Private Const MAX_COMPUTERNAME_LENGTH As Long = 31
Private Const NO_ERR As Long = 0

Private Function Hostname() As String
Dim i As Long, l As Long, s As String
  s = Space$(MAX_COMPUTERNAME_LENGTH)
  l = Len(s) + 1
  i = GetComputerName(StrPtr(s), l)
  Debug.Assert i <> 0
  Debug.Assert l <> 0
  Hostname = Left$(s, l)
End Function

Sub Main()
  Debug.Assert Hostname() = Environ$("COMPUTERNAME")
End Sub
