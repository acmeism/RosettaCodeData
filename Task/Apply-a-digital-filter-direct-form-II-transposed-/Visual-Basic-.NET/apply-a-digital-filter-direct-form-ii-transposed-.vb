Module Module1

    Function Filter(a As Double(), b As Double(), signal As Double()) As Double()
        Dim result(signal.Length - 1) As Double
        For i = 1 To signal.Length
            Dim tmp = 0.0
            For j = 1 To b.Length
                If i - j < 0 Then
                    Continue For
                End If
                tmp += b(j - 1) * signal(i - j)
            Next
            For j = 2 To a.Length
                If i - j < 0 Then
                    Continue For
                End If
                tmp -= a(j - 1) * result(i - j)
            Next
            tmp /= a(0)
            result(i - 1) = tmp
        Next
        Return result
    End Function

    Sub Main()
        Dim a() As Double = {1.0, -0.000000000000000277555756, 0.333333333, -1.85037171E-17}
        Dim b() As Double = {0.16666667, 0.5, 0.5, 0.16666667}

        Dim signal() As Double = {
            -0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412,
            -0.662370894973, -1.00700480494, -0.404707073677, 0.800482325044,
            0.743500089861, 1.01090520172, 0.741527555207, 0.277841675195,
            0.400833448236, -0.2085993586, -0.172842103641, -0.134316096293,
            0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589
        }

        Dim result = Filter(a, b, signal)
        For i = 1 To result.Length
            Console.Write("{0,11:F8}", result(i - 1))
            Console.Write(If(i Mod 5 <> 0, ", ", vbNewLine))
        Next
    End Sub

End Module
