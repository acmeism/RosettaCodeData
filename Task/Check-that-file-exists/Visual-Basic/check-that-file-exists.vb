'declarations:
Public Declare Function GetFileAttributes Lib "kernel32" _
  Alias "GetFileAttributesA" (ByVal lpFileName As String) As Long
Public Const INVALID_FILE_ATTRIBUTES As Long = -1
Public Const ERROR_SHARING_VIOLATION As Long = 32&

'implementation:
Public Function FileExists(ByVal Filename As String) As Boolean
Dim l As Long
l = GetFileAttributes(Filename)
  If l <> INVALID_FILE_ATTRIBUTES Then
    FileExists = ((l And vbDirectory) = 0)
  ElseIf Err.LastDllError = ERROR_SHARING_VIOLATION Then
    FileExists = True
  End If
End Function
