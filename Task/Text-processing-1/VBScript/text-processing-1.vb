Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
			"\data.txt",1)

bad_readings_total = 0
good_readings_total = 0
data_gap = 0
start_date = ""
end_date = ""
tmp_datax_gap = 0
tmp_start_date = ""

Do Until objFile.AtEndOfStream
	bad_readings = 0
	good_readings = 0
	line_total = 0
	line = objFile.ReadLine
	token = Split(line,vbTab)
	n = 1
	Do While n <= UBound(token)
		If n + 1 <= UBound(token) Then
			If CInt(token(n+1)) < 1 Then
				bad_readings = bad_readings + 1
				bad_readings_total = bad_readings_total + 1
				'Account for bad readings.
				If tmp_start_date = "" Then
					tmp_start_date = token(0)
				End If
				tmp_data_gap = tmp_data_gap + 1
			Else
				good_readings = good_readings + 1
				line_total = line_total + CInt(token(n))
				good_readings_total = good_readings_total + 1
				'Sum up the bad readings.
				If (tmp_start_date <> "") And (tmp_data_gap > data_gap) Then
					start_date = tmp_start_date
					end_date = token(0)
					data_gap = tmp_data_gap
					tmp_start_date = ""
					tmp_data_gap = 0
				Else
					tmp_start_date = ""
					tmp_data_gap = 0
				End If
			End If	
		End If
		n = n + 2
	Loop
	line_avg = line_total/good_readings
	WScript.StdOut.Write "Date: " & token(0) & vbTab &_
		"Bad Reads: " & bad_readings & vbTab &_
		"Good Reads: " & good_readings & vbTab &_
		"Line Total: " & FormatNumber(line_total,3) & vbTab &_
		"Line Avg: " & FormatNumber(line_avg,3)
	WScript.StdOut.WriteLine
Loop
WScript.StdOut.WriteLine
WScript.StdOut.Write "Maximum run of " & data_gap &_
	" consecutive bad readings from " & start_date & " to " &_
	end_date & "."
WScript.StdOut.WriteLine
objFile.Close
Set objFSO = Nothing
