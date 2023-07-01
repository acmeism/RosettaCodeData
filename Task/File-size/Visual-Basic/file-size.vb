Option Explicit

----

Sub DisplayFileSize(ByVal Path As String, ByVal Filename As String)
Dim i As Long
  If InStr(Len(Path), Path, "\") = 0 Then
    Path = Path & "\"
  End If
  On Error Resume Next 'otherwise runtime error if file does not exist
  i = FileLen(Path & Filename)
  If Err.Number = 0 Then
    Debug.Print "file size: " & CStr(i) & " Bytes"
  Else
    Debug.Print "error: " & Err.Description
  End If
End Sub

----

Sub Main()
  DisplayFileSize CurDir(), "input.txt"
  DisplayFileSize CurDir(), "innputt.txt"
  DisplayFileSize Environ$("SystemRoot"), "input.txt"
End Sub
