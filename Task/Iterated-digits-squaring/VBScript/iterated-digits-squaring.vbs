start_time = Now
cnt = 0
For i = 1 To 100000000
	n = i
	sum = 0
	Do Until n = 1 Or n = 89
		For j = 1 To Len(n)
			sum = sum + (CLng(Mid(n,j,1))^2)
		Next
		n = sum
		sum = 0
	Loop
	If n = 89 Then
		cnt = cnt + 1
	End If
Next
end_time = Now

WScript.Echo "Elapse Time: " & DateDiff("s",start_time,end_time) &_
			vbCrLf & "Count: " & cnt
