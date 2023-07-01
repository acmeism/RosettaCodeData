Module Module1
Function MianChowla(ByVal n As Integer) As Integer()
        Dim mc(n - 1) As Integer, sums, ts As New HashSet(Of Integer),
        sum As Integer : mc(0) = 1 : sums.Add(2)
        For i As Integer = 1 To n - 1
            For j As Integer = mc(i - 1) + 1 To Integer.MaxValue
                mc(i) = j
                For k As Integer = 0 To i
                    sum = mc(k) + j
                    If sums.Contains(sum) Then ts.Clear() : Exit For
                    ts.Add(sum)
                Next
                If ts.Count > 0 Then sums.UnionWith(ts) : Exit For
            Next
        Next
        Return mc
    End Function

    Sub Main(ByVal args As String())
        Const n As Integer = 100
        Dim sw As New Stopwatch(), str As String = " of the Mian-Chowla sequence are:" & vbLf
        sw.Start() : Dim mc As Integer() = MianChowla(n) : sw.Stop()
        Console.Write("The first 30 terms{1}{2}{0}{0}Terms 91 to 100{1}{3}{0}{0}" &
            "Computation time was {4}ms.{0}", vbLf, str,
            String.Join(" ", mc.Take(30)), String.Join(" ", mc.Skip(n - 10)), sw.ElapsedMilliseconds)
    End Sub
End Module
