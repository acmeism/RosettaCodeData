Declare Function GetModuleFileName Lib "kernel32" Alias "GetModuleFileNameA" (ByVal hModule As Long, ByVal lpFileName As String, ByVal nSize As Long) As Long
Dim fullpath As String * 260, appname As String, namelen As Long
namelen = GetModuleFileName (0, fullpath, 260)
fullpath = Left$(fullpath, namelen)
If InStr(fullpath, "\") Then
    appname = Mid$(fullpath, InStrRev(fullpath, "\") + 1)
Else
    appname = fullpath
End If
