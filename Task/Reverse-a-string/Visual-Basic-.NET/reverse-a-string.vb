#Const REDIRECTOUT = True

Module Program
    Const OUTPATH = "out.txt"

    ReadOnly TestCases As String() = {"asdf", "as⃝df̅", "Les Misérables"}

    ' SIMPLE VERSION
    Function Reverse(s As String) As String
        Dim t = s.ToCharArray()
        Array.Reverse(t)
        Return New String(t)
    End Function

    ' EXTRA CREDIT VERSION
    Function ReverseElements(s As String) As String
        ' In .NET, a text element is series of code units that is displayed as one character, and so reversing the text
        ' elements of the string correctly handles combining character sequences and surrogate pairs.
        Dim elements = Globalization.StringInfo.GetTextElementEnumerator(s)
        Return String.Concat(AsEnumerable(elements).OfType(Of String).Reverse())
    End Function

    ' Wraps an IEnumerator, allowing it to be used as an IEnumerable.
    Iterator Function AsEnumerable(enumerator As IEnumerator) As IEnumerable
        Do While enumerator.MoveNext()
            Yield enumerator.Current
        Loop
    End Function

    Sub Main()
        Const INDENT = "    "

#If REDIRECTOUT Then
        Const OUTPATH = "out.txt"
        Using s = IO.File.Open(OUTPATH, IO.FileMode.Create),
              sw As New IO.StreamWriter(s)
            Console.SetOut(sw)
#Else
        Try
            Console.OutputEncoding = Text.Encoding.ASCII
            Console.OutputEncoding = Text.Encoding.UTF8
            Console.OutputEncoding = Text.Encoding.Unicode
        Catch ex As Exception
            Console.WriteLine("Failed to set console encoding to Unicode." & vbLf)
        End Try
#End If
            For Each c In TestCases
                Console.WriteLine(c)
                Console.WriteLine(INDENT & "SIMPLE:   " & Reverse(c))
                Console.WriteLine(INDENT & "ELEMENTS: " & ReverseElements(c))
                Console.WriteLine()
            Next
#If REDIRECTOUT Then
        End Using
#End If
    End Sub
End Module
