Sub write_event(event_type,msg)
	Set objShell = CreateObject("WScript.Shell")
	Select Case event_type
		Case "SUCCESS"
			n = 0
		Case "ERROR"
			n = 1
		Case "WARNING"
			n = 2
		Case "INFORMATION"
			n = 4
		Case "AUDIT_SUCCESS"
			n = 8
		Case "AUDIT_FAILURE"
			n = 16
	End Select
	objShell.LogEvent n, msg
	Set objShell = Nothing
End Sub

Call write_event("INFORMATION","This is a test information.")
