Function dns_query(url,ver)
	Set r = New RegExp
	r.Pattern = "Pinging.+?\[(.+?)\].+"
	Set objshell = CreateObject("WScript.Shell")
	Set objexec = objshell.Exec("%comspec% /c " & "ping -" & ver & " " & url)
	WScript.StdOut.WriteLine "URL: " & url
	Do Until objexec.StdOut.AtEndOfStream
		line = objexec.StdOut.ReadLine
		If r.Test(line) Then
			WScript.StdOut.WriteLine "IP Version " &_
				ver & ": " & r.Replace(line,"$1")
		End If
	Loop
End Function

Call dns_query(WScript.Arguments(0),WScript.Arguments(1))
