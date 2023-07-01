Option Explicit

Const sURL="http://rosettacode.org/"

Dim oHTTP
Set oHTTP = CreateObject("Microsoft.XmlHTTP")

On Error Resume Next
oHTTP.Open "GET", sURL, False
oHTTP.Send ""
If Err.Number = 0 Then
     WScript.Echo oHTTP.responseText
Else
     Wscript.Echo "error " & Err.Number & ": " & Err.Description
End If

Set oHTTP = Nothing
