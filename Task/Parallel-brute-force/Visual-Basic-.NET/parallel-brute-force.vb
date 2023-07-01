Imports System.Text

Module Module1

    Function Matches(a As Byte(), b As Byte()) As Boolean
        For i = 0 To 31
            If a(i) <> b(i) Then
                Return False
            End If
        Next
        Return True
    End Function

    Function StringHashToByteArray(s As String) As Byte()
        Return Enumerable.Range(0, s.Length / 2).Select(Function(i) CType(Convert.ToInt16(s.Substring(i * 2, 2), 16), Byte)).ToArray
    End Function

    Sub Main()
        Dim h1 = StringHashToByteArray("1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad")
        Dim h2 = StringHashToByteArray("3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b")
        Dim h3 = StringHashToByteArray("74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f")

        Parallel.For(0, 26, Sub(a As Integer)
                                Dim sha = Security.Cryptography.SHA256.Create()
                                Dim password(4) As Byte
                                Dim hash As Byte()

                                password(0) = 97 + a

                                password(1) = 97
                                While password(1) < 123
                                    password(2) = 97
                                    While password(2) < 123
                                        password(3) = 97
                                        While password(3) < 123
                                            password(4) = 97
                                            While password(4) < 123
                                                hash = sha.ComputeHash(password)
                                                If Matches(h1, hash) OrElse Matches(h2, hash) OrElse Matches(h3, hash) Then
                                                    Console.WriteLine(Encoding.ASCII.GetString(password) + " => " + BitConverter.ToString(hash).ToLower().Replace("-", ""))
                                                End If
                                                password(4) += 1
                                            End While
                                            password(3) += 1
                                        End While
                                        password(2) += 1
                                    End While
                                    password(1) += 1
                                End While
                            End Sub)
    End Sub

End Module
