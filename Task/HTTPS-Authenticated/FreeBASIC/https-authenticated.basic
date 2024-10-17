#include once "windows.bi"
#include once "win/wininet.bi"

' Create InternetOpen and InternetConnect objects
Dim As HINTERNET hInternet, hConnect
hInternet = InternetOpen("FreeBASIC", INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0)
hConnect = InternetConnect(hInternet, "www.abc.com", INTERNET_DEFAULT_HTTP_PORT, "<username>", "<password>", INTERNET_SERVICE_HTTP, 0, 0)

' Open request
Dim As HINTERNET hRequest
hRequest = HttpOpenRequest(hConnect, "GET", "/xyz/index.html", NULL, NULL, NULL, INTERNET_FLAG_SECURE, 0)

#If USE_PROXY
    ' Set proxy
    Dim As INTERNET_PROXY_INFO proxyInfo
    proxyInfo.dwAccessType = INTERNET_OPEN_TYPE_PROXY
    proxyInfo.lpszProxy = "10.167.1.1:80"
    proxyInfo.lpszProxyBypass = NULL
    InternetSetOption(hRequest, INTERNET_OPTION_PROXY, @proxyInfo, Sizeof(proxyInfo))
#endif

' Set timeouts
Dim As DWORD dwTimeout = 1000
InternetSetOption(hRequest, INTERNET_OPTION_CONNECT_TIMEOUT, @dwTimeout, Sizeof(dwTimeout))
InternetSetOption(hRequest, INTERNET_OPTION_RECEIVE_TIMEOUT, @dwTimeout, Sizeof(dwTimeout))
InternetSetOption(hRequest, INTERNET_OPTION_SEND_TIMEOUT, @dwTimeout, Sizeof(dwTimeout))

' Send request
HttpSendRequest(hRequest, NULL, 0, NULL, 0)

' Print response
Dim As Byte buffer(4096)
Dim As DWORD dwRead
While InternetReadFile(hRequest, @buffer(0), Sizeof(buffer), @dwRead) And dwRead > 0
    For i As Integer = 0 To dwRead-1
        Print Chr(buffer(i));
    Next
Wend

' Clean up
InternetCloseHandle(hRequest)
InternetCloseHandle(hConnect)
InternetCloseHandle(hInternet)

Sleep
