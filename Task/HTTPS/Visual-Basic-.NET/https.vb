Imports System.Net

Dim client As WebClient = New WebClient()
Dim content As String = client.DownloadString("https://sourceforge.net")
Console.WriteLine(content)
