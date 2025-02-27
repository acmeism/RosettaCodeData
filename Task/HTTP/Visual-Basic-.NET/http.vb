Imports System.Net

Module RCHttp

    Public Sub Main(args As String())
        Dim client As New WebClient()
        Dim content As String = client.DownloadString("http://www.google.com")
        Console.WriteLine(content)
    End Sub

End Module
