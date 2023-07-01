Module Module1

    Structure Pair
        Dim a, b As Integer
        Sub New(x As Integer, y As Integer)
            a = x : b = y
        End Sub
    End Structure

    Dim min As Integer = 1, max As Integer = 250
    Dim p5() As Long,
        sum2 As SortedDictionary(Of Long, Pair) = New SortedDictionary(Of Long, Pair),
        sum2m(29) As SortedDictionary(Of Long, Pair)

    Function Fmt(p As Pair) As String
        Return String.Format("{0}^5 + {1}^5", p.a, p.b)
    End Function

    Sub Init()
        p5(0) = 0 : p5(min) = CLng(min) * min : p5(min) *= p5(min) * min
        For i As Integer = min To max - 1
            For j As Integer = i + 1 To max
                p5(j) = CLng(j) * j : p5(j) *= p5(j) * j
                If j = max Then Continue For
                sum2.Add(p5(i) + p5(j), New Pair(i, j))
            Next
        Next
    End Sub

    Sub InitM()
        For i As Integer = 0 To 29 : sum2m(i) = New SortedDictionary(Of Long, Pair) : Next
        p5(0) = 0 : p5(min) = CLng(min) * min : p5(min) *= p5(min) * min
        For i As Integer = min To max - 1
            For j As Integer = i + 1 To max
                p5(j) = CLng(j) * j : p5(j) *= p5(j) * j
                If j = max Then Continue For
                Dim x As Long = p5(i) + p5(j)
                sum2m(x Mod 30).Add(x, New Pair(i, j))
            Next
        Next
    End Sub

    Sub Calc(Optional findLowest As Boolean = True)
        For i As Integer = min To max : Dim p As Long = p5(i)
            For Each s In sum2.Keys
                Dim t As Long = p - s : If t <= 0 Then Exit For
                If sum2.Keys.Contains(t) AndAlso sum2.Item(t).a > sum2.Item(s).b Then
                    Console.WriteLine("  {1} + {2} = {0}^5", i,
                        Fmt(sum2.Item(s)), Fmt(sum2.Item(t)))
                    If findLowest Then Exit Sub
                End If
            Next : Next
    End Sub

    Function CalcM(m As Integer) As List(Of String)
        Dim res As New List(Of String)
        For i As Integer = min To max
            Dim pm As Integer = i Mod 30,
                mp As Integer = (pm - m + 30) Mod 30
            For Each s In sum2m(m).Keys
                Dim t As Long = p5(i) - s : If t <= 0 Then Exit For
                If sum2m(mp).Keys.Contains(t) AndAlso
                  sum2m(mp).Item(t).a > sum2m(m).Item(s).b Then
                    res.Add(String.Format("  {1} + {2} = {0}^5",
                        i, Fmt(sum2m(m).Item(s)), Fmt(sum2m(mp).Item(t))))
                End If
            Next : Next
        Return res
    End Function

    Function Snip(s As String) As Integer
        Dim p As Integer = s.IndexOf("=") + 1
        Return s.Substring(p, s.IndexOf("^", p) - p)
    End Function

    Function CompareRes(ByVal x As String, ByVal y As String) As Integer
        CompareRes = Snip(x).CompareTo(Snip(y))
        If CompareRes = 0 Then CompareRes = x.CompareTo(y)
    End Function

    Function Validify(def As Integer, s As String) As Integer
        Validify = def : Dim t As Integer = 0 : Integer.TryParse(s, t)
        If t >= 1 AndAlso Math.Pow(t, 5) < (Long.MaxValue >> 1) Then Validify = t
    End Function

    Sub Switch(ByRef a As Integer, ByRef b As Integer)
        Dim t As Integer = a : a = b : b = t
    End Sub

    Sub Main(args As String())
        Select Case args.Count
            Case 1 : max = Validify(max, args(0))
            Case > 1
                min = Validify(min, args(0))
                max = Validify(max, args(1))
                If max < min Then Switch(max, min)
        End Select
        Console.WriteLine("Paired powers, checking from {0} to {1}...", min, max)
        For i As Integer = 0 To 1
            ReDim p5(max) : sum2.Clear()
            Dim st As DateTime = DateTime.Now
            Init() : Calc(i = 0)
            Console.WriteLine("{0}  Computation time to {2} was {1} seconds{0}", vbLf,
                (DateTime.Now - st).TotalSeconds, If(i = 0, "find lowest one", "check entire space"))
        Next
        For i As Integer = 0 To 1
            Console.WriteLine("Paired powers with Mod 30 shortcut (entire space) {2}, checking from {0} to {1}...",
                min, max, If(i = 0, "sequential", "parallel"))
            ReDim p5(max)
            Dim res As List(Of String) = New List(Of String)
            Dim st As DateTime = DateTime.Now
            Dim taskList As New List(Of Task(Of List(Of String)))
            InitM()
            Select Case i
                Case 0
                    For j As Integer = 0 To 29
                        res.AddRange(CalcM(j))
                    Next
                Case 1
                    For j As Integer = 0 To 29 : Dim jj = j
                        taskList.Add(Task.Run(Function() CalcM(jj)))
                    Next
                    Task.WhenAll(taskList)
                    For Each item In taskList.Select(Function(t) t.Result)
                        res.AddRange(item) : Next
            End Select
            res.Sort(AddressOf CompareRes)
            For Each item In res
                Console.WriteLine(item) : Next
            Console.WriteLine("{0}  Computation time was {1} seconds{0}", vbLf, (DateTime.Now - st).TotalSeconds)
        Next
        If Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub
End Module
