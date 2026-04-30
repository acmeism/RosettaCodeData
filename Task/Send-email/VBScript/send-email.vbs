Function send_mail(from,recipient,cc,subject,message)
	With CreateObject("CDO.Message")
		.From = from
		.To = recipient
		.CC = cc
		.Subject = subject
		.Textbody = message
		.Configuration.Fields.Item _
			("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		.Configuration.Fields.Item _
			("http://schemas.microsoft.com/cdo/configuration/smtpserver") = _
		        "mystmpserver"
		.Configuration.Fields.Item _
		    ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		.Configuration.Fields.Update
		.Send
	End With
End Function

Call send_mail("Alerts@alerts.org","jkspeed@jkspeed.org","","Test Email","this is a test message")
