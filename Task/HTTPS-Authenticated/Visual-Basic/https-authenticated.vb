Sub Main()
'  in the "references" dialog of the IDE, check
'  "Microsoft WinHTTP Services, version 5.1" (winhttp.dll)
Dim HttpReq As WinHttp.WinHttpRequest
Const WINHTTP_FLAG_SECURE_PROTOCOL_TLS1     As Long = &H80&
Const WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1   As Long = &H200&
Const WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2   As Long = &H800&
Const HTTPREQUEST_PROXYSETTING_PROXY        As Long = 2
#Const USE_PROXY = 1
  Set HttpReq = New WinHttp.WinHttpRequest
  HttpReq.Open "GET", "https://www.abc.com/xyz/index.html"
  HttpReq.Option(WinHttpRequestOption_SecureProtocols) = WINHTTP_FLAG_SECURE_PROTOCOL_TLS1 Or _
                                                         WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1 Or _
                                                         WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2
  HttpReq.SetCredentials "<username>", "<password>", 0&
#If USE_PROXY Then
  HttpReq.SetProxy HTTPREQUEST_PROXYSETTING_PROXY, "10.167.1.1:80"
#End If
  HttpReq.SetTimeouts 1000, 1000, 1000, 1000
  HttpReq.Send
  Debug.Print HttpReq.ResponseText
End Sub
