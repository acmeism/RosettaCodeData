Module Module1

    Dim CA As Char() = "0123456789ABC".ToCharArray()

    Sub FourSquare(lo As Integer, hi As Integer, uni As Boolean, sy As Char())
        If sy IsNot Nothing Then Console.WriteLine("a b c d e f g" & vbLf & "-------------")
        Dim r = Enumerable.Range(lo, hi - lo + 1).ToList(), u As New List(Of Integer),
            t As Integer, cn As Integer = 0
        For Each a In r
            u.Add(a)
            For Each b In r
                If uni AndAlso u.Contains(b) Then Continue For
                u.Add(b)
                t = a + b
                For Each c In r : If uni AndAlso u.Contains(c) Then Continue For
                    u.Add(c)
                    For d = a - c To a - c
                        If d < lo OrElse d > hi OrElse uni AndAlso u.Contains(d) OrElse
                            t <> b + c + d Then Continue For
                        u.Add(d)
                        For Each e In r
                            If uni AndAlso u.Contains(e) Then Continue For
                            u.Add(e)
                            For f = b + c - e To b + c - e
                                If f < lo OrElse f > hi OrElse uni AndAlso u.Contains(f) OrElse
                                    t <> d + e + f Then Continue For
                                u.Add(f)
                                For g = t - f To t - f : If g < lo OrElse g > hi OrElse
                                    uni AndAlso u.Contains(g) Then Continue For
                                    cn += 1 : If sy IsNot Nothing Then _
                                        Console.WriteLine("{0} {1} {2} {3} {4} {5} {6}",
                                            sy(a), sy(b), sy(c), sy(d), sy(e), sy(f), sy(g))
                                Next : u.Remove(f) : Next : u.Remove(e) : Next : u.Remove(d)
                    Next : u.Remove(c) : Next : u.Remove(b) : Next : u.Remove(a)
        Next : Console.WriteLine("{0} {1}unique solutions for [{2},{3}]{4}",
                                 cn, If(uni, "", "non-"), lo, hi, vbLf)
    End Sub

    Sub main()
        fourSquare(1, 7, True, CA)
        fourSquare(3, 9, True, CA)
        fourSquare(0, 9, False, Nothing)
        fourSquare(5, 12, True, CA)
    End Sub

End Module
