Imports System.Text

Module Program
    Private Function GetStory() As String
        Dim input As New StringBuilder()
        Do
            Dim nextLine = Console.ReadLine()
            If String.IsNullOrEmpty(nextLine) Then Exit Do
            input.AppendLine(nextLine)
        Loop

        Dim story = input.ToString()
        Return story
    End Function

    Sub Main()
        Dim input As String = GetStory()

        Dim result As New StringBuilder()
        Dim replacements As New Dictionary(Of String, String)

        For i = 0 To input.Length - 1
            Dim curChar = input(i)

            ' For all characters but '<', append it and move on.
            If curChar <> "<"c Then
                result.Append(curChar)
            Else
                ' If the character before was a backslash, then replace the backslash in the result with a '<' and move on.
                If i > 0 AndAlso input(i - 1) = "\"c Then
                    result(result.Length - 1) = "<"c
                    Continue For
                End If

                ' Search for the first '>' that isn't preceded by a backslash.
                Dim closeBracketPos = -1
                For ind = i To input.Length - 1
                    If input(ind) = ">"c AndAlso input(ind - 1) <> "\"c Then
                        closeBracketPos = ind
                        Exit For
                    End If
                Next

                ' The search failed to find a '>'.
                If closeBracketPos < 0 Then
                    Console.WriteLine($"ERROR: Template starting at position {i} is not closed.")
                    Environment.Exit(-1)
                End If

                ' The text between the current character and the found '>' character, with escape sequences simplified.
                Dim key As String = input.Substring(i + 1, closeBracketPos - i - 1).Replace("\>", ">", StringComparison.Ordinal)

                Dim subst As String = Nothing
                ' Ask for and store a replacement value if there isn't already one for the key.
                If Not replacements.TryGetValue(key, subst) Then
                    Console.Write($"Enter a {key}: ")
                    subst = Console.ReadLine()
                    replacements.Add(key, subst)
                End If

                result.Append(subst)
                i = closeBracketPos
            End If
        Next

        Console.WriteLine()
        Console.Write(result)
    End Sub
End Module
