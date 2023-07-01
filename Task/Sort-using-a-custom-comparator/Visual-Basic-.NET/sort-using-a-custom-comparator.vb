Imports System

Module Sorting_Using_a_Custom_Comparator
    Function CustomComparator(ByVal x As String, ByVal y As String) As Integer
        Dim result As Integer
        result = y.Length - x.Length
        If result = 0 Then
            result = String.Compare(x, y, True)
        End If
        Return result
    End Function

    Sub Main()
        Dim strings As String() = {"test", "Zoom", "strings", "a"}

        Array.Sort(strings, New Comparison(Of String)(AddressOf CustomComparator))
    End Sub
End Module
