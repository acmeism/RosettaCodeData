Dim doorIsOpen(100), pass, currentDoor, text

For currentDoor = 0 To 99
	doorIsOpen(currentDoor) = False
Next

For pass = 0 To 99
	For currentDoor = pass To 99 Step pass + 1
		doorIsOpen(currentDoor) = Not doorIsOpen(currentDoor)
	Next
Next

For currentDoor = 0 To 99
	text = "Door #" & currentDoor + 1 & " is "
	If doorIsOpen(currentDoor) Then
		text = text & "open."
	Else
		text = text & "closed."
	End If
	WScript.Echo(text)
Next
