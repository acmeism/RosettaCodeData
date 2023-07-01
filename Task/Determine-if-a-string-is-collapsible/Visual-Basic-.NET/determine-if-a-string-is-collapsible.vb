Module Module1

    Function Collapse(s As String) As String
        If String.IsNullOrEmpty(s) Then
            Return ""
        End If
        Return s(0) + New String(Enumerable.Range(1, s.Length - 1).Where(Function(i) s(i) <> s(i - 1)).Select(Function(i) s(i)).ToArray)
    End Function

    Sub Main()
        Dim input() = {
             "",
            "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
            "headmistressship",
            ControlChars.Quote + "If I were two-faced, would I be wearing this one?" + ControlChars.Quote + " --- Abraham Lincoln ",
            "..1111111111111111111111111111111111111111111111111111111111111117777888",
            "I never give 'em hell, I just tell the truth, and they think it's hell. ",
            "                                                    --- Harry S Truman  "
           }
        For Each s In input
            Console.WriteLine($"old: {s.Length} «««{s}»»»")
            Dim c = Collapse(s)
            Console.WriteLine($"new: {c.Length} «««{c}»»»")
        Next
    End Sub

End Module
