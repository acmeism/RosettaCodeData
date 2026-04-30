TCPStartup()
$socket = TCPListen("0.0.0.0",8080)
$string = "Goodbye, World!"
While 1
   Do
	  $newConnection = TCPAccept($socket)
	  Sleep(1)
   Until $newConnection <> -1
   $content = TCPRecv($newConnection, 2048)
   If StringLen($content) > 0 Then
	  TCPSend($newConnection, Binary("HTTP/1.1 200 OK" & @CRLF))
	  TCPSend($newConnection, Binary("Content-Type: text/html" & @CRLF))
	  TCPSend($newConnection, Binary("Content-Length: "& BinaryLen($string) & @CRLF & @CRLF))
	  TCPSend($newConnection, $string)
   EndIf
   TCPCloseSocket($newConnection)
WEnd
