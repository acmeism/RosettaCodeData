Module GraphemeLength
    ' Wraps an IEnumerator, allowing it to be used as an IEnumerable.
    Private Iterator Function AsEnumerable(enumerator As IEnumerator) As IEnumerable
        Do While enumerator.MoveNext()
            Yield enumerator.Current
        Loop
    End Function

    Function GraphemeCount(s As String) As Integer
        Dim elements = Globalization.StringInfo.GetTextElementEnumerator(s)
        Return AsEnumerable(elements).OfType(Of String).Count()
    End Function
End Module
