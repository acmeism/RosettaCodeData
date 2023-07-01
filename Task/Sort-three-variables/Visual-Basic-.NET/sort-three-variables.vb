Module Module1

    Sub Swap(Of T)(ByRef a As T, ByRef b As T)
        Dim c = a
        a = b
        b = c
    End Sub

    Sub Sort(Of T As IComparable(Of T))(ByRef a As T, ByRef b As T, ByRef c As T)
        If a.CompareTo(b) > 0 Then
            Swap(a, b)
        End If
        If a.CompareTo(c) > 0 Then
            Swap(a, c)
        End If
        If b.CompareTo(c) > 0 Then
            Swap(b, c)
        End If
    End Sub

    Sub Main()
        Dim x = 77444
        Dim y = -12
        Dim z = 0
        Sort(x, y, z)
        Console.WriteLine((x, y, z))

        Dim a = "lions, tigers, and"
        Dim b = "bears, oh my!"
        Dim c = "(from the 'Wizard of OZ')"
        Sort(a, b, c)
        Console.WriteLine((a, b, c))
    End Sub

End Module
