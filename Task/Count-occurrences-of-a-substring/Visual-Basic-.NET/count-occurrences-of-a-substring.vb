Module Count_Occurrences_of_a_Substring
    Sub Main()
        Console.WriteLine(CountSubstring("the three truths", "th"))
        Console.WriteLine(CountSubstring("ababababab", "abab"))
        Console.WriteLine(CountSubstring("abaabba*bbaba*bbab", "a*b"))
        Console.WriteLine(CountSubstring("abc", ""))
    End Sub

    Function CountSubstring(str As String, substr As String) As Integer
        Dim count As Integer = 0
        If (Len(str) > 0) And (Len(substr) > 0) Then
            Dim p As Integer = InStr(str, substr)
            Do While p <> 0
                p = InStr(p + Len(substr), str, substr)
                count += 1
            Loop
        End If
        Return count
    End Function
End Module
