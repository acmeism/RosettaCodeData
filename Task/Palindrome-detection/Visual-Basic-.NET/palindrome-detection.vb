Module Module1

    Function IsPalindrome(p As String) As Boolean
        Dim temp = p.ToLower().Replace(" ", "")
        Return StrReverse(temp) = temp
    End Function

    Sub Main()
        Console.WriteLine(IsPalindrome("In girum imus nocte et consumimur igni"))
    End Sub

End Module
