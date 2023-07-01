Module Module1

    Structure Interval
        Dim start As Integer
        Dim last As Integer
        Dim print As Boolean

        Sub New(s As Integer, l As Integer, p As Boolean)
            start = s
            last = l
            print = p
        End Sub
    End Structure

    Sub Main()
        Dim intervals As Interval() = {
            New Interval(2, 1_000, True),
            New Interval(1_000, 4_000, True),
            New Interval(2, 10_000, False),
            New Interval(2, 100_000, False),
            New Interval(2, 1_000_000, False),
            New Interval(2, 10_000_000, False),
            New Interval(2, 100_000_000, False),
            New Interval(2, 1_000_000_000, False)
        }
        For Each intv In intervals
            If intv.start = 2 Then
                Console.WriteLine("eban numbers up to and including {0}:", intv.last)
            Else
                Console.WriteLine("eban numbers between {0} and {1} (inclusive):", intv.start, intv.last)
            End If

            Dim count = 0
            For i = intv.start To intv.last Step 2
                Dim b = i \ 1_000_000_000
                Dim r = i Mod 1_000_000_000
                Dim m = r \ 1_000_000
                r = i Mod 1_000_000
                Dim t = r \ 1_000
                r = r Mod 1_000
                If m >= 30 AndAlso m <= 66 Then
                    m = m Mod 10
                End If
                If t >= 30 AndAlso t <= 66 Then
                    t = t Mod 10
                End If
                If r >= 30 AndAlso r <= 66 Then
                    r = r Mod 10
                End If
                If b = 0 OrElse b = 2 OrElse b = 4 OrElse b = 6 Then
                    If m = 0 OrElse m = 2 OrElse m = 4 OrElse m = 6 Then
                        If t = 0 OrElse t = 2 OrElse t = 4 OrElse t = 6 Then
                            If r = 0 OrElse r = 2 OrElse r = 4 OrElse r = 6 Then
                                If intv.print Then
                                    Console.Write("{0} ", i)
                                End If
                                count += 1
                            End If
                        End If
                    End If
                End If
            Next
            If intv.print Then
                Console.WriteLine()
            End If
            Console.WriteLine("count = {0}", count)
            Console.WriteLine()
        Next
    End Sub

End Module
