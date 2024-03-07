Module Module1

    Function CheckISBN13(code As String) As Boolean
        code = code.Replace("-", "").Replace(" ", "")
        If code.Length <> 13 Then
            Return False
        End If
        Dim sum = 0
        For Each i_d In code.Select(Function(digit, index) (index, digit))
            Dim index = i_d.index
            Dim digit = i_d.digit
            If Char.IsDigit(digit) Then
                sum += (Asc(digit) - Asc("0")) * If(index Mod 2 = 0, 1, 3)
            Else
                Return False
            End If
        Next
        Return sum Mod 10 = 0
    End Function

    Sub Main()
        Console.WriteLine(CheckISBN13("978-0596528126"))
        Console.WriteLine(CheckISBN13("978-0596528120"))
        Console.WriteLine(CheckISBN13("978-1788399081"))
        Console.WriteLine(CheckISBN13("978-1788399083"))
    End Sub

End Module
