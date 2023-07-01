Public Sub roots_of_unity()
    For n = 2 To 9
        Debug.Print n; "th roots of 1:"
        For r00t = 0 To n - 1
            Debug.Print "   Root "; r00t & ": "; WorksheetFunction.Complex(Cos(2 * WorksheetFunction.Pi() * r00t / n), _
                Sin(2 * WorksheetFunction.Pi() * r00t / n))
        Next r00t
        Debug.Print
    Next n
End Sub
