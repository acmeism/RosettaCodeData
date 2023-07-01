Sub Main()
Dim HttpReq As WinHttp.WinHttpRequest
'  in the "references" dialog of the IDE, check
'  "Microsoft WinHTTP Services, version 5.1" (winhttp.dll)
Const HTTPREQUEST_PROXYSETTING_PROXY        As Long = 2
Const WINHTTP_FLAG_SECURE_PROTOCOL_TLS1     As Long = &H80&
Const WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1   As Long = &H200&
Const WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2   As Long = &H800&
#Const USE_PROXY = 1
  Set HttpReq = New WinHttp.WinHttpRequest
  HttpReq.Open "GET", "https://groups.google.com/robots.txt"
  HttpReq.Option(WinHttpRequestOption_SecureProtocols) = WINHTTP_FLAG_SECURE_PROTOCOL_TLS1 Or _
                                                         WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1 Or _
                                                         WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2
#If USE_PROXY Then
  HttpReq.SetProxy HTTPREQUEST_PROXYSETTING_PROXY, "my_proxy:80"
#End If
  HttpReq.SetTimeouts 1000, 1000, 1000, 1000
  HttpReq.Send
  Debug.Print HttpReq.ResponseText
End Sub
