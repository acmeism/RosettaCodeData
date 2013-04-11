Imports System
Imports System.IO
Imports System.Net.Sockets

Public Class Program
    Public Shared Sub Main(ByVal args As String[])
        Dim tcp As New TcpClient("localhost", 256)
        Dim writer As New StreamWriter(tcp.GetStream())

        writer.Write("hello socket world")
        writer.Flush()

        tcp.Close()
    End Sub
End Class
