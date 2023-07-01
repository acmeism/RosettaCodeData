Module Module1

    Const WIDTH = 81
    Const HEIGHT = 5
    Dim lines(HEIGHT, WIDTH) As Char

    Sub Init()
        For i = 0 To HEIGHT - 1
            For j = 0 To WIDTH - 1
                lines(i, j) = "*"
            Next
        Next
    End Sub

    Sub Cantor(start As Integer, len As Integer, index As Integer)
        Dim seg As Integer = len / 3
        If seg = 0 Then
            Return
        End If
        For i = index To HEIGHT - 1
            For j = start + seg To start + seg * 2 - 1
                lines(i, j) = " "
            Next
        Next
        Cantor(start, seg, index + 1)
        Cantor(start + seg * 2, seg, index + 1)
    End Sub

    Sub Main()
        Init()
        Cantor(0, WIDTH, 1)
        For i = 0 To HEIGHT - 1
            For j = 0 To WIDTH - 1
                Console.Write(lines(i, j))
            Next
            Console.WriteLine()
        Next
    End Sub

End Module
