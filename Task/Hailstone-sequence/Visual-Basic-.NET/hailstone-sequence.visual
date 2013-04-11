Module HailstoneSequence
    Sub Main()
        ' Checking sequence of 27.

        Dim l As List(Of Long) = HailstoneSequence(27)
        Console.WriteLine("27 has {0} elements in sequence:", l.Count())

        For i As Integer = 0 To 3 : Console.Write("{0}, ", l(i)) : Next
        Console.Write("... ")
        For i As Integer = l.Count - 4 To l.Count - 1 : Console.Write(", {0}", l(i)) : Next

        Console.WriteLine()

        ' Finding longest sequence for numbers below 100000.

        Dim max As Integer = 0
        Dim maxCount As Integer = 0

        For i = 1 To 99999
            l = HailstoneSequence(i)
            If l.Count > maxCount Then
                max = i
                maxCount = l.Count
            End If
        Next
        Console.WriteLine("Max elements in sequence for number below 100k: {0} with {1} elements.", max, maxCount)
        Console.ReadLine()
    End Sub

    Private Function HailstoneSequence(ByVal n As Long) As List(Of Long)
        Dim valList As New List(Of Long)()
        valList.Add(n)

        Do Until n = 1
            n = IIf(n Mod 2 = 0, n / 2, (3 * n) + 1)
            valList.Add(n)
        Loop

        Return valList
    End Function

End Module
