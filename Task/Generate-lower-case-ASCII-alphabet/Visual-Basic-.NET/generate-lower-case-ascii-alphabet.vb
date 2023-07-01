Module LowerASCII

    Sub Main()
        Dim alphabets As New List(Of Char)
        For i As Integer = Asc("a") To Asc("z")
            alphabets.Add(Chr(i))
        Next
        Console.WriteLine(String.Join("", alphabets.ToArray))
    End Sub

End Module
