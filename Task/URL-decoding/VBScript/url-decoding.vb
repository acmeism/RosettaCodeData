Function RegExTest(str,patrn)
    Dim regEx
    Set regEx = New RegExp
    regEx.IgnoreCase = True
    regEx.Pattern = patrn
    RegExTest = regEx.Test(str)
End Function

Function URLDecode(sStr)
    Dim str,code,a0
    str=""
    code=sStr
    code=Replace(code,"+"," ")
    While len(code)>0
        If InStr(code,"%")>0 Then
            str = str & Mid(code,1,InStr(code,"%")-1)
            code = Mid(code,InStr(code,"%"))
            a0 = UCase(Mid(code,2,1))
            If a0="U" And RegExTest(code,"^%u[0-9A-F]{4}") Then
                str = str & ChrW((Int("&H" & Mid(code,3,4))))
                code = Mid(code,7)
            ElseIf a0="E" And RegExTest(code,"^(%[0-9A-F]{2}){3}") Then
                str = str & ChrW((Int("&H" & Mid(code,2,2)) And 15) * 4096 + (Int("&H" & Mid(code,5,2)) And 63) * 64 + (Int("&H" & Mid(code,8,2)) And 63))
                code = Mid(code,10)
            ElseIf a0>="C" And a0<="D" And RegExTest(code,"^(%[0-9A-F]{2}){2}") Then
                str = str & ChrW((Int("&H" & Mid(code,2,2)) And 3) * 64 + (Int("&H" & Mid(code,5,2)) And 63))
                code = Mid(code,7)
            ElseIf (a0<="B" Or a0="F") And RegExTest(code,"^%[0-9A-F]{2}") Then
                str = str & Chr(Int("&H" & Mid(code,2,2)))
                code = Mid(code,4)
            Else
                str = str & "%"
                code = Mid(code,2)
            End If
        Else
            str = str & code
            code = ""
        End If
    Wend
    URLDecode = str
End Function

url = "http%3A%2F%2Ffoo%20bar%C3%A8%2F"
WScript.Echo "Encoded URL: " & url & vbCrLf &_
	"Decoded URL: " & UrlDecode(url)
