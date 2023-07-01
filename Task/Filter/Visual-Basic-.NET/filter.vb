Module Filter

    Sub Main()
        Dim array() As Integer = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
        Dim newEvenArray() As Integer

        Console.WriteLine("Current Array:")
        For Each i As Integer In array
            Console.WriteLine(i)
        Next

        newEvenArray = filterArrayIntoNewArray(array)

        Console.WriteLine("New Filtered Array:")
        For Each i As Integer In newEvenArray
            Console.WriteLine(i)
        Next

        array = changeExistingArray(array)

        Console.WriteLine("Orginal Array After Filtering:")
        For Each i As Integer In array
            Console.WriteLine(i)
        Next
    End Sub

    Private Function changeExistingArray(array() As Integer) As Integer()
        Return filterArrayIntoNewArray(array)
    End Function

    Private Function filterArrayIntoNewArray(array() As Integer) As Integer()
        Dim result As New List(Of Integer)
        For Each element As Integer In array
            If element Mod 2 = 0 Then
                result.Add(element)
            End If
        Next
        Return result.ToArray
    End Function

End Module
