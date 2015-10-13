Function parse_ip(addr)
	'ipv4 pattern
	Set ipv4_pattern = New RegExp
	ipv4_pattern.Global = True
	ipv4_pattern.Pattern = "(\d{1,3}\.){3}\d{1,3}"
	'ipv6 pattern
	Set ipv6_pattern = New RegExp
	ipv6_pattern.Global = True
	ipv6_pattern.Pattern = "([0-9a-fA-F]{0,4}:){2}[0-9a-fA-F]{0,4}"
	'test if address is ipv4
	If ipv4_pattern.Test(addr) Then
		port = Split(addr,":")
		octet = Split(port(0),".")
		ipv4_hex = ""
		For i = 0 To UBound(octet)
			If octet(i) <= 255 And octet(i) >= 0 Then
				ipv4_hex = ipv4_hex & Right("0" & Hex(octet(i)),2)
			Else
				ipv4_hex = "Erroneous Address"
				Exit For
			End If
		Next
		parse_ip = "Test Case: " & addr & vbCrLf &_
		           "Address: " & ipv4_hex & vbCrLf
		If UBound(port) = 1 Then
			If port(1) <= 65535 And port(1) >= 0 Then
				parse_ip = parse_ip & "Port: " & port(1) & vbCrLf
			Else
				parse_ip = parse_ip & "Port: Invalid" & vbCrLf
			End If
		End If
	End If
	'test if address is ipv6
	If ipv6_pattern.Test(addr) Then
		parse_ip = "Test Case: " & addr & vbCrLf
		port_v6 = "Port: "
		ipv6_hex = ""
		'check and extract port information if any
		If InStr(1,addr,"[") Then
			'extract the port
			port_v6 = port_v6 & Mid(addr,InStrRev(addr,"]")+2,Len(addr)-Len(Mid(addr,1,InStrRev(addr,"]")+1)))
			'extract the address
			addr = Mid(addr,InStrRev(addr,"[")+1,InStrRev(addr,"]")-(InStrRev(addr,"[")+1))
		End If
		word = Split(addr,":")
		word_count = 0
		For i = 0 To UBound(word)
			If word(i) = "" Then
				If i < UBound(word) Then
					If Int((7-(i+1))/2) = 1 Then
						k = 1
					ElseIf UBound(word) < 6 Then
						k = Int((7-(i+1))/2)
					ElseIf UBound(word) >= 6 Then
						k = Int((7-(i+1))/2)-1
					End If
					For j = 0 To k
						ipv6_hex = ipv6_hex & "0000"
						word_count = word_count + 1
					Next
				Else
					For j = 0 To (7-word_count)
						ipv6_hex = ipv6_hex & "0000"
					Next
				End If
			Else
				ipv6_hex = ipv6_hex & Right("0000" & word(i),4)
				word_count = word_count + 1
			End If
		Next
		parse_ip = parse_ip & "Address: " & ipv6_hex &_
				vbCrLf & port_v6 & vbCrLf
	End If
	'test if the address in invalid
	If ipv4_pattern.Test(addr) = False And ipv6_pattern.Test(addr) = False Then
		parse_ip = "Test Case: " & addr & vbCrLf &_
		           "Address: Invalid Address" & vbCrLf
	End If
End Function

'Testing the function
ip_arr = Array("127.0.0.1","127.0.0.1:80","::1",_
	"[::1]:80","2605:2700:0:3::4713:93e3","[2605:2700:0:3::4713:93e3]:80","RosettaCode")

For n = 0 To UBound(ip_arr)
	WScript.StdOut.Write parse_ip(ip_arr(n)) & vbCrLf
Next
