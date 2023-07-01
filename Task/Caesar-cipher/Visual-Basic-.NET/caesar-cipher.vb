Module Module1

    Function Encrypt(ch As Char, code As Integer) As Char
        If Not Char.IsLetter(ch) Then
            Return ch
        End If

        Dim offset = AscW(If(Char.IsUpper(ch), "A"c, "a"c))
        Dim test = (AscW(ch) + code - offset) Mod 26 + offset
        Return ChrW(test)
    End Function

    Function Encrypt(input As String, code As Integer) As String
        Return New String(input.Select(Function(ch) Encrypt(ch, code)).ToArray())
    End Function

    Function Decrypt(input As String, code As Integer) As String
        Return Encrypt(input, 26 - code)
    End Function

    Sub Main()
        Dim str = "Pack my box with five dozen liquor jugs."

        Console.WriteLine(str)
        str = Encrypt(str, 5)
        Console.WriteLine("Encrypted: {0}", str)
        str = Decrypt(str, 5)
        Console.WriteLine("Decrypted: {0}", str)
    End Sub

End Module
