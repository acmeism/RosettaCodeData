Imports System.Security.Cryptography
Imports System.Text

Module MD5hash
    Sub Main(args As String())
        Console.WriteLine(GetMD5("Visual Basic .Net"))
    End Sub

    Private Function GetMD5(plainText As String) As String
        Dim hash As String = ""

        Using hashObject As MD5 = MD5.Create()
            Dim ptBytes As Byte() = hashObject.ComputeHash(Encoding.UTF8.GetBytes(plainText))
            Dim hashBuilder As New StringBuilder

            For i As Integer = 0 To ptBytes.Length - 1
                hashBuilder.Append(ptBytes(i).ToString("X2"))
            Next
            hash = hashBuilder.ToString
        End Using

        Return hash
    End Function

End Module
