Module Module1

    Dim resu As New List(Of Integer)

    Function TestAbundant(n As Integer, ByRef divs As List(Of Integer)) As Boolean
        divs = New List(Of Integer)
        Dim sum As Integer = -n : For i As Integer = Math.Sqrt(n) To 1 Step -1
            If n Mod i = 0 Then divs.Add(i) : Dim j As Integer = n / i : divs.Insert(0, j) : sum += i + j
        Next : divs(0) = sum - divs(0) : Return divs(0) > 0
    End Function

    Function subList(src As List(Of Integer), Optional first As Integer = Integer.MinValue) As List(Of Integer)
        subList = src.ToList : subList.RemoveAt(1)
    End Function

    Function semiperfect(divs As List(Of Integer)) As Boolean
        If divs.Count < 2 Then Return False
        Select Case divs.First.CompareTo(divs(1))
            Case 0 : Return True
            Case -1 : Return semiperfect(subList(divs))
            Case 1 : Dim t As List(Of Integer) = subList(divs) : t(0) -= divs(1)
                If semiperfect(t) Then Return True Else t(0) = divs.First : Return semiperfect(t)
        End Select : Return False ' execution can't get here, just for compiler warning
    End Function

    Function Since(et As TimeSpan) As String ' big ugly routine to prettify the elasped time
        If et > New TimeSpan(2000000) Then
            Dim s As String = " " & et.ToString(), p As Integer = s.IndexOf(":"), q As Integer = s.IndexOf(".")
            If q < p Then s = s.Insert(q, "Days") : s = s.Replace("Days.", "Days, ")
            p = s.IndexOf(":") : s = s.Insert(p, "h") : s = s.Replace("h:", "h ")
            p = s.IndexOf(":") : s = s.Insert(p, "m") : s = s.Replace("m:", "m ")
            s = s.Replace(" 0", " ").Replace(" 0h", " ").Replace(" 0m", " ") & "s"
            Return s.TrimStart()
        Else
            If et > New TimeSpan(1500) Then
                Return et.TotalMilliseconds.ToString() & "ms"
            Else
                If et > New TimeSpan(15) Then
                    Return (et.TotalMilliseconds * 1000.0).ToString() & "µs"
                Else
                    Return (et.TotalMilliseconds * 1000000.0).ToString() & "ns"
                End If
            End If
        End If
    End Function

    Sub Main(args As String())
        Dim sw As New Stopwatch, st As Integer = 2, stp As Integer = 1020, count As Integer = 0
        Dim max As Integer = 25, halted As Boolean = False
        If args.Length > 0 Then _
            Dim t As Integer = Integer.MaxValue : If Integer.TryParse(args(0), t) Then max = If(t > 0, t, Integer.MaxValue)
        If max = Integer.MaxValue Then
            Console.WriteLine("Calculating weird numbers, press a key to halt.")
            stp *= 10
        Else
            Console.WriteLine("The first {0} weird numbers:", max)
        End If
        If max < 25 Then stp = 140
        sw.Start()
        Do : Parallel.ForEach(Enumerable.Range(st, stp),
            Sub(n)
                Dim divs As List(Of Integer) = Nothing
                If TestAbundant(n, divs) AndAlso Not semiperfect(divs) Then
                    SyncLock resu : resu.Add(n) : End SyncLock
                End If
            End Sub)
            If resu.Count > 0 Then
                resu.Sort()
                If count + resu.Count > max Then
                    resu = resu.Take(max - count).ToList
                End If
                Console.Write(String.Join(" ", resu) & " ")
                count += resu.Count : resu.Clear()
            End If
            If Console.KeyAvailable Then Console.ReadKey() : halted = True : Exit Do
            st += stp
        Loop Until count >= max
        sw.Stop()
        If max < Integer.MaxValue Then
            Console.WriteLine(vbLf & "Computation time was {0}.", Since(sw.Elapsed))
            If halted Then Console.WriteLine("Halted at number {0}.", count)
        Else
            Console.WriteLine(vbLf & "Computation time was {0} for the first {1} weird numbers.", Since(sw.Elapsed), count)
        End If
    End Sub
End Module
