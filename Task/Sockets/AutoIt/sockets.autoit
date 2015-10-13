Func _HelloWorldSocket()
	TCPStartup()
	$Socket = TCPConnect("127.0.0.1", 256)
	TCPSend($Socket, "Hello World")
	TCPCloseSocket($Socket)
	TCPShutdown()
EndFunc
