Module Module1

    Structure Pair
        Dim a, b As Integer
        Sub New(x as integer, y as integer)
            a = x : b = y
        End Sub
    End Structure

    Dim max As Integer = 250
    Dim p5() As Long,
        sum2 As SortedDictionary(Of Long, Pair) = New SortedDictionary(Of Long, Pair)

    Function Fmt(p As Pair) As String
        Return String.Format("{0}^5 + {1}^5", p.a, p.b)
    End Function

    Sub Init()
        p5(0) = 0 : p5(1) = 1 : For i As Integer = 1 To max - 1
            For j As Integer = i + 1 To max
                p5(j) = CLng(j) * j : p5(j) *= p5(j) * j
                sum2.Add(p5(i) + p5(j), New Pair(i, j))
            Next
        Next
    End Sub

    Sub Calc(Optional findLowest As Boolean = True)
        For i As Integer = 1 To max : Dim p As Long = p5(i)
            For Each s In sum2.Keys
                Dim t As Long = p - s : If t <= 0 Then Exit For
                If sum2.Keys.Contains(t) AndAlso sum2.Item(t).a > sum2.Item(s).b Then
                    Console.WriteLine("  {1} + {2} = {0}^5", i, Fmt(sum2.Item(s)), Fmt(sum2.Item(t)))
                    If findLowest Then Exit Sub
                End If
            Next : Next
    End Sub

    Sub Main(args As String())
        If args.Count > 0 Then
            Dim t As Integer = 0 : Integer.TryParse(args(0), t)
            If t > 0 AndAlso t < 5405 Then max = t
        End If
        Console.WriteLine("Checking from 1 to {0}...", max)
        For i As Integer = 0 To 1
            ReDim p5(max) : sum2.Clear()
            Dim st As DateTime = DateTime.Now
            Init() : Calc(i = 0)
            Console.WriteLine("{0}  Computation time to {2} was {1} seconds{0}", vbLf,
                (DateTime.Now - st).TotalSeconds, If(i = 0, "find lowest one", "check entire space"))
        Next
        If Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub
End Module
