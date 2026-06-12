Module Module1

    Structure Node
        Private ReadOnly m_val As String
        Private ReadOnly m_parsed As List(Of String)

        Sub New(initial As String)
            m_val = initial
            m_parsed = New List(Of String)
        End Sub

        Sub New(s As String, p As List(Of String))
            m_val = s
            m_parsed = p
        End Sub

        Public Function Value() As String
            Return m_val
        End Function

        Public Function Parsed() As List(Of String)
            Return m_parsed
        End Function
    End Structure

    Function WordBreak(s As String, dictionary As List(Of String)) As List(Of List(Of String))
        Dim matches As New List(Of List(Of String))
        Dim q As New Queue(Of Node)
        q.Enqueue(New Node(s))
        While q.Count > 0
            Dim node = q.Dequeue()
            REM check if fully parsed
            If node.Value.Length = 0 Then
                matches.Add(node.Parsed)
            Else
                For Each word In dictionary
                    REM check for match
                    If node.Value.StartsWith(word) Then
                        Dim valNew = node.Value.Substring(word.Length, node.Value.Length - word.Length)
                        Dim parsedNew As New List(Of String)
                        parsedNew.AddRange(node.Parsed)
                        parsedNew.Add(word)
                        q.Enqueue(New Node(valNew, parsedNew))
                    End If
                Next
            End If
        End While
        Return matches
    End Function

    Sub Main()
        Dim dict As New List(Of String) From {"a", "aa", "b", "ab", "aab"}
        For Each testString In {"aab", "aa b"}
            Dim matches = WordBreak(testString, dict)
            Console.WriteLine("String = {0}, Dictionary = {1}. Solutions = {2}", testString, dict, matches.Count)
            For Each match In matches
                Console.WriteLine(" Word Break = [{0}]", String.Join(", ", match))
            Next
            Console.WriteLine()
        Next

        dict = New List(Of String) From {"abc", "a", "ac", "b", "c", "cb", "d"}
        For Each testString In {"abcd", "abbc", "abcbcd", "acdbc", "abcdd"}
            Dim matches = WordBreak(testString, dict)
            Console.WriteLine("String = {0}, Dictionary = {1}. Solutions = {2}", testString, dict, matches.Count)
            For Each match In matches
                Console.WriteLine(" Word Break = [{0}]", String.Join(", ", match))
            Next
            Console.WriteLine()
        Next
    End Sub

End Module
