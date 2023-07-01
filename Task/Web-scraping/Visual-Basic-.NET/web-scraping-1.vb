Imports System.Net
Imports System.IO
        Dim client As WebClient = New WebClient()
        Dim content As String = client.DownloadString("http://tycho.usno.navy.mil/cgi-bin/timer.pl")
        Dim sr As New StringReader(content)
        While sr.peek <> -1
            Dim s As String = sr.ReadLine
            If s.Contains("UTC") Then
                Dim time As String() = s.Substring(4).Split(vbTab)
                Console.WriteLine(time(0))
            End If
        End While
