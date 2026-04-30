start = Now
Set nlookup = CreateObject("Scripting.Dictionary")
Set uniquepair = CreateObject("Scripting.Dictionary")

For i = 1 To 20000
	sum = 0
	For n = 1 To 20000
		If n < i Then
			If i Mod n = 0 Then
				sum = sum + n
			End If
		End If
	Next
	nlookup.Add i,sum
Next

For j = 1 To 20000
	sum = 0
	For m = 1 To 20000
		If m < j Then
			If j Mod m = 0 Then
				sum = sum + m
			End If
		End If
	Next
	If nlookup.Exists(sum) And nlookup.Item(sum) = j And j <> sum _
		And uniquepair.Exists(sum) = False Then
			uniquepair.Add j,sum
	End If
Next

For Each key In uniquepair.Keys
	WScript.Echo key & ":" & uniquepair.Item(key)
Next

WScript.Echo "Execution Time: " & DateDiff("s",Start,Now) & " seconds"
