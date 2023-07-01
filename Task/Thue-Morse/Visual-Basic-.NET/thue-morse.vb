Imports System.Text

Module Module1

    Sub Sequence(steps As Integer)
        Dim sb1 As New StringBuilder("0")
        Dim sb2 As New StringBuilder("1")
        For index = 1 To steps
            Dim tmp = sb1.ToString
            sb1.Append(sb2)
            sb2.Append(tmp)
        Next
        Console.WriteLine(sb1)
    End Sub

    Sub Main()
        Sequence(6)
    End Sub

End Module
