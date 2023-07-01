Module Module1

    ReadOnly STX As Char = Chr(&H2)
    ReadOnly ETX As Char = Chr(&H3)

    Sub Rotate(Of T)(a As T())
        Dim o = a.Last
        For i = a.Length - 1 To 1 Step -1
            a(i) = a(i - 1)
        Next
        a(0) = o
    End Sub

    Private Function Compare(s1 As String, s2 As String) As Integer
        Dim i = 0
        While i < s1.Length AndAlso i < s2.Length
            Dim a = s1(i)
            Dim b = s2(i)
            If a < b Then
                Return -1
            End If
            If b < a Then
                Return 1
            End If
            i += 1
        End While
        If s1.Length < s2.Length Then
            Return -1
        End If
        If s2.Length < s1.Length Then
            Return 1
        End If
        Return 0
    End Function

    Function Bwt(s As String) As String
        If s.Any(Function(c) c = STX OrElse c = ETX) Then
            Throw New ArgumentException("Input can't contain STX or ETX")
        End If
        Dim ss = (STX + s + ETX).ToCharArray
        Dim table As New List(Of String)
        For i = 0 To ss.Length - 1
            table.Add(New String(ss))
            Rotate(ss)
        Next
        table.Sort(Function(a As String, b As String) Compare(a, b))
        Return New String(table.Select(Function(a) a.Last).ToArray)
    End Function

    Function Ibwt(r As String) As String
        Dim len = r.Length
        Dim sa(len - 1) As String
        Dim table As New List(Of String)(sa)
        For i = 0 To len - 1
            For j = 0 To len - 1
                table(j) = r(j) + table(j)
            Next
            table.Sort(Function(a As String, b As String) Compare(a, b))
        Next
        For Each row In table
            If row.Last = ETX Then
                Return row.Substring(1, len - 2)
            End If
        Next
        Return ""
    End Function

    Function MakePrintable(s As String) As String
        Return s.Replace(STX, "^").Replace(ETX, "|")
    End Function

    Sub Main()
        Dim tests As String() = {
            "banana",
            "appellee",
            "dogwood",
            "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
            "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
            STX + "ABC" + ETX
        }

        For Each test In tests
            Console.WriteLine(MakePrintable(test))
            Console.Write(" --> ")

            Dim t = ""
            Try
                t = Bwt(test)
                Console.WriteLine(MakePrintable(t))
            Catch ex As Exception
                Console.WriteLine("ERROR: {0}", ex.Message)
            End Try

            Dim r = Ibwt(t)
            Console.WriteLine(" --> {0}", r)
            Console.WriteLine()
        Next
    End Sub

End Module
