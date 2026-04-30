Function parse_url(url)
	parse_url = "URL: " & url
	If InStr(url,"//") Then
		'parse the scheme
		scheme = Split(url,"//")
		parse_url = parse_url & vbcrlf & "Scheme: " & Mid(scheme(0),1,Len(scheme(0))-1)
		'parse the domain
		domain = Split(scheme(1),"/")
		'check if the domain includes a username, password, and port
		If InStr(domain(0),"@") Then
			cred = Split(domain(0),"@")
			If InStr(cred(0),".") Then
				username = Mid(cred(0),1,InStr(1,cred(0),".")-1)
				password = Mid(cred(0),InStr(1,cred(0),".")+1,Len(cred(0))-InStr(1,cred(0),"."))
			ElseIf InStr(cred(0),":") Then
				username = Mid(cred(0),1,InStr(1,cred(0),":")-1)
				password = Mid(cred(0),InStr(1,cred(0),":")+1,Len(cred(0))-InStr(1,cred(0),":"))
			End If
			parse_url = parse_url & vbcrlf & "Username: " & username & vbCrLf &_
				"Password: " & password
			'check if the domain have a port
			If InStr(cred(1),":") Then
				host = Mid(cred(1),1,InStr(1,cred(1),":")-1)
				port = Mid(cred(1),InStr(1,cred(1),":")+1,Len(cred(1))-InStr(1,cred(1),":"))
				parse_url = parse_url & vbCrLf & "Domain: " & host & vbCrLf & "Port: " & port
			Else
				parse_url = parse_url & vbCrLf & "Domain: " & cred(1)
			End If
		ElseIf InStr(domain(0),":") And Instr(domain(0),"[") = False And Instr(domain(0),"]") = False Then
				host = Mid(domain(0),1,InStr(1,domain(0),":")-1)
				port = Mid(domain(0),InStr(1,domain(0),":")+1,Len(domain(0))-InStr(1,domain(0),":"))
				parse_url = parse_url & vbCrLf & "Domain: " & host & vbCrLf & "Port: " & port
		ElseIf Instr(domain(0),"[") And Instr(domain(0),"]:") Then
			host = Mid(domain(0),1,InStr(1,domain(0),"]"))
			port = Mid(domain(0),InStr(1,domain(0),"]")+2,Len(domain(0))-(InStr(1,domain(0),"]")+1))
			parse_url = parse_url & vbCrLf & "Domain: " & host & vbCrLf & "Port: " & port
		Else
			parse_url = parse_url & vbCrLf & "Domain: " & domain(0)
		End If
		'parse the path if exist
		If UBound(domain) > 0 Then
			For i = 1 To UBound(domain)
				If i < UBound(domain) Then
					path = path & domain(i) & "/"
				ElseIf InStr(domain(i),"?") Then
					path = path & Mid(domain(i),1,InStr(1,domain(i),"?")-1)
					If InStr(domain(i),"#") Then
						query = Mid(domain(i),InStr(1,domain(i),"?")+1,InStr(1,domain(i),"#")-InStr(1,domain(i),"?")-1)
						fragment = Mid(domain(i),InStr(1,domain(i),"#")+1,Len(domain(i))-InStr(1,domain(i),"#"))
						path = path & vbcrlf & "Query: " & query & vbCrLf & "Fragment: " & fragment
					Else
						query = Mid(domain(i),InStr(1,domain(i),"?")+1,Len(domain(i))-InStr(1,domain(i),"?"))
						path = path & vbcrlf & "Query: " & query
					End If
				ElseIf InStr(domain(i),"#") Then
					fragment = Mid(domain(i),InStr(1,domain(i),"#")+1,Len(domain(i))-InStr(1,domain(i),"#"))
					path = path & Mid(domain(i),1,InStr(1,domain(i),"#")-1) & vbCrLf &_
						 "Fragment: " & fragment
				Else
					path = path & domain(i)
				End If
			Next
			parse_url = parse_url & vbCrLf & "Path: " & path
		End If
	ElseIf InStr(url,":") Then
		scheme = Mid(url,1,InStr(1,url,":")-1)
		path = Mid(url,InStr(1,url,":")+1,Len(url)-InStr(1,url,":"))
		parse_url = parse_url & vbcrlf & "Scheme: " & scheme & vbCrLf & "Path: " & path
	Else
		parse_url = parse_url & vbcrlf & "Invalid!!!"
	End If

End Function

'test the convoluted function :-(
WScript.StdOut.WriteLine parse_url("foo://example.com:8042/over/there?name=ferret#nose")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("ftp://ftp.is.co.za/rfc/rfc1808.txt")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("http://www.ietf.org/rfc/rfc2396.txt#header1")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("mailto:John.Doe@example.com")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("news:comp.infosystems.www.servers.unix")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("tel:+1-816-555-1212")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("telnet://192.0.2.16:80/")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("urn:oasis:names:specification:docbook:dtd:xml:4.1.2")
WScript.StdOut.WriteLine "-------------------------------"
WScript.StdOut.WriteLine parse_url("this code is messy, long, and needs a makeover!!!")
