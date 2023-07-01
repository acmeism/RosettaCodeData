' MAC Vendor lookup - based on the C# sample.

Imports System
Imports System.Net

Module LookupMac

    Public Sub Main(args() As String)

        Dim macAddress As String = If(args.Length < 1, "88:53:2E:67:07:BE", args(0))
        Dim uri As New Uri("http://api.macvendors.com/" & WebUtility.UrlEncode(macAddress))
        Dim wc As New WebClient()
        Console.Out.WriteLine(macAddress & "    " & wc.DownloadString(uri))

    End Sub

End Module
