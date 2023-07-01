Option Explicit On
Option Infer On
Option Strict On

Module Program
    Function FormatEnumerable(source As IEnumerable(Of String)) As String
        Dim res As New Text.StringBuilder("{")

        Using en = source.GetEnumerator()
            Dim moreThanOne As Boolean = False
            Dim nxt = If(en.MoveNext(), en.Current, String.Empty)

            Do While en.MoveNext()
                If moreThanOne Then res.Append(", ")
                moreThanOne = True

                res.Append(nxt)
                nxt = en.Current
            Loop

            Dim lastItem = If(moreThanOne, " and ", "") & nxt
            Return res.ToString() & lastItem & "}"
        End Using
    End Function

    Function FormatArray(source As String()) As String
        Select Case source.Length
            Case 0 : Return "{}"
            Case 1 : Return "{" & source(0) & "}"
            Case Else : Return "{" & String.Join(", ", source.Take(source.Length - 1)) & " and " & source(source.Length - 1) & "}"
        End Select
    End Function

    Sub Main()
        Dim cases As String()() = {Array.Empty(Of String), New String() {"ABC"}, New String() {"ABC", "DEF"}, New String() {"ABC", "DEF", "G", "H"}}
        For Each c In cases
            Console.WriteLine(FormatArray(c))
            Console.WriteLine(FormatEnumerable(c))
        Next
    End Sub
End Module
