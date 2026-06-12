#include once "file.bi"

Function GetCachePath(sourceFile As String) As String
    Return Exepath & "\cache\" & sourceFile & ".exe"
End Function

Function NeedsRecompile(sourceFile As String, cacheFile As String) As Boolean
    If Fileexists(cacheFile) = 0 Then Return True
    Return Filedatetime(sourceFile) > Filedatetime(cacheFile)
End Function

Function CompileSource(sourceFile As String, cacheFile As String) As Boolean
    Dim As String cmd = "fbc -x " & cacheFile & " " & sourceFile
    Return Shell(cmd) = 0
End Function

' Main script handler
Dim sourceFile As String = Command(1)
If Len(sourceFile) = 0 Then End 1

' Create cache directory if needed
Mkdir Exepath & "\cache"

' Get cache path and check if recompilation needed
Dim As String cacheFile = GetCachePath(sourceFile)
If NeedsRecompile(sourceFile, cacheFile) Then
    If CompileSource(sourceFile, cacheFile) = 0 Then End 1
End If

' Execute cached binary with arguments
Dim As String args = ""
For i As Integer = 2 To __fb_argc__-1
    args &= " " & Command(i)
Next
Shell(cacheFile & args)
