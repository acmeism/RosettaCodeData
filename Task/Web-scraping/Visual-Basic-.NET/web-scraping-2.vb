Imports System.Net
        Dim client As WebClient = New WebClient()
        Dim content As String = client.DownloadString("http://tycho.usno.navy.mil/cgi-bin/timer.pl")
        Dim lines() As String = Split(content, vbLf) 'may need vbCrLf
        For Each line In lines
            If line.Contains("UTC") Then
                Dim time As String() = line.Substring(4).Split(vbTab)
                Console.WriteLine(time(0))
            End If
        Next
