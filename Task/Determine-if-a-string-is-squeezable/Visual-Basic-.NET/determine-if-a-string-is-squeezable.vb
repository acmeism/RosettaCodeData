Imports System.Linq.Enumerable

Module Module1

    Function Squeeze(s As String, c As Char) As String
        If String.IsNullOrEmpty(s) Then
            Return ""
        End If
        Return s(0) + New String(Range(1, s.Length - 1).Where(Function(i) s(i) <> c OrElse s(i) <> s(i - 1)).Select(Function(i) s(i)).ToArray())
    End Function

    Sub SqueezeAndPrint(s As String, c As Char)
        Console.WriteLine("squeeze: '{0}'", c)
        Console.WriteLine("old: {0} «««{1}»»»", s.Length, s)
        s = Squeeze(s, c)
        Console.WriteLine("new: {0} «««{1}»»»", s.Length, s)
    End Sub

    Sub Main()
        Const QUOTE = """"

        SqueezeAndPrint("", " ")
        SqueezeAndPrint(QUOTE & "If I were two-faced, would I be wearing this one?" & QUOTE & " --- Abraham Lincoln ", "-")
        SqueezeAndPrint("..1111111111111111111111111111111111111111111111111111111111111117777888", "7")
        SqueezeAndPrint("I never give 'em hell, I just tell the truth, and they think it's hell. ", ".")

        Dim s = "                                                    --- Harry S Truman  "
        SqueezeAndPrint(s, " ")
        SqueezeAndPrint(s, "-")
        SqueezeAndPrint(s, "r")
    End Sub

End Module
