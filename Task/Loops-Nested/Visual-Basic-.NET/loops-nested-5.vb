    Sub Find20Impl(arr As Integer(,))
        For r = 0 To arr.GetLength(0) - 1
            For c = 0 To arr.GetLength(1) - 1
                Dim val = arr(r, c)
                Console.WriteLine(val)
                If val = 20 Then Exit Sub
               'If val = 20 Then Return ' Equivalent to above.
            Next
        Next
    End Sub
