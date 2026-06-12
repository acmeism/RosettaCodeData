Module Module1

    Function LongestCommonPrefix(ParamArray sa() As String) As String
        If IsNothing(sa) Then
            Return "" REM special case
        End If
        Dim ret = ""
        Dim idx = 0

        While True
            Dim thisLetter = Nothing
            For Each word In sa
                If idx = word.Length Then
                    REM if we reach the end of a word then we are done
                    Return ret
                End If
                If IsNothing(thisLetter) Then
                    REM if this is the first word, thennote the letter we are looking for
                    thisLetter = word(idx)
                End If
                If thisLetter <> word(idx) Then
                    Return ret
                End If
            Next

            REM if we haven't said we are done the this position passed
            ret += thisLetter
            idx += 1
        End While

        Return ""
    End Function

    Sub Main()
        Console.WriteLine(LongestCommonPrefix("interspecies", "interstellar", "interstate"))
        Console.WriteLine(LongestCommonPrefix("throne", "throne"))
        Console.WriteLine(LongestCommonPrefix("throne", "dungeon"))
        Console.WriteLine(LongestCommonPrefix("throne", "", "throne"))
        Console.WriteLine(LongestCommonPrefix("cheese"))
        Console.WriteLine(LongestCommonPrefix(""))
        Console.WriteLine(LongestCommonPrefix(Nothing))
        Console.WriteLine(LongestCommonPrefix("prefix", "suffix"))
        Console.WriteLine(LongestCommonPrefix("foo", "foobar"))
    End Sub

End Module
