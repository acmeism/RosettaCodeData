Const sec = "00:00:01"

Dim As String infile = ""
Input "Enter infile of audio file to be trimmed : ", infile

Dim As String outfile = ""
Input "Enter infile of output file              : ", outfile

Dim As Integer squelch = 0
Print "Enter squelch level % max (1 to 10) : ";
While squelch < 1 Or squelch > 10
    Input "", squelch
Wend
Dim As String squelchS = Str(squelch) & "%"

Dim As String tmp1 = "tmp1_" & infile
Dim As String tmp2 = "tmp2_" & infile

' Trim audio below squelch level from start and output to tmp1.
Shell "sox " & infile & " " & tmp1 & " silence 1 " & Sec & " " & squelchS

' Reverse tmp1 to tmp2.
Shell "sox " & tmp1 & " " & tmp2 & " reverse"

' Trim audio below squelch level from tmp2 and output to tmp1.
Shell "sox " & tmp2 & " " & tmp1 & " silence 1 " & Sec & " " & squelchS

' Reverse tmp1 to the output file.
Shell "sox " & tmp1 & " " & outfile & " reverse"

' Remove the temporary files.
Kill tmp1
Kill tmp2

Sleep
