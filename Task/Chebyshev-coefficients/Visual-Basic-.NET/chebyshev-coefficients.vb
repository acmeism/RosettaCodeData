Module Module1

    Structure ChebyshevApprox
        Public ReadOnly coeffs As List(Of Double)
        Public ReadOnly domain As Tuple(Of Double, Double)

        Public Sub New(func As Func(Of Double, Double), n As Integer, domain As Tuple(Of Double, Double))
            coeffs = ChebCoef(func, n, domain)
            Me.domain = domain
        End Sub

        Public Function Eval(x As Double) As Double
            Return ChebEval(coeffs, domain, x)
        End Function
    End Structure

    Function AffineRemap(from As Tuple(Of Double, Double), x As Double, t0 As Tuple(Of Double, Double)) As Double
        Return t0.Item1 + (x - from.Item1) * (t0.Item2 - t0.Item1) / (from.Item2 - from.Item1)
    End Function

    Function ChebCoef(fVals As List(Of Double)) As List(Of Double)
        Dim n = fVals.Count
        Dim theta = Math.PI / n
        Dim retval As New List(Of Double)
        For i = 1 To n
            retval.Add(0.0)
        Next
        For i = 1 To n
            Dim ii = i - 1
            Dim f = fVals(ii) * 2.0 / n
            Dim phi = (ii + 0.5) * theta
            Dim c1 = Math.Cos(phi)
            Dim s1 = Math.Sin(phi)
            Dim c = 1.0
            Dim s = 0.0
            For j = 1 To n
                Dim jj = j - 1
                retval(jj) += f * c
                ' update c -> cos(j*phi) for next value of j
                Dim cNext = c * c1 - s * s1
                s = c * s1 + s * c1
                c = cNext
            Next
        Next
        Return retval
    End Function

    Function ChebCoef(func As Func(Of Double, Double), n As Integer, domain As Tuple(Of Double, Double)) As List(Of Double)
        Dim Remap As Func(Of Double, Double)
        Remap = Function(x As Double)
                    Return AffineRemap(Tuple.Create(-1.0, 1.0), x, domain)
                End Function
        Dim theta = Math.PI / n
        Dim fVals As New List(Of Double)
        For i = 1 To n
            fVals.Add(0.0)
        Next
        For i = 1 To n
            Dim ii = i - 1
            fVals(ii) = func(Remap(Math.Cos((ii + 0.5) * theta)))
        Next
        Return ChebCoef(fVals)
    End Function

    Function ChebEval(coef As List(Of Double), x As Double) As Double
        Dim a = 1.0
        Dim b = x
        Dim c As Double
        Dim retval = 0.5 * coef(0) + b * coef(1)
        Dim it = coef.GetEnumerator
        it.MoveNext()
        it.MoveNext()
        While it.MoveNext
            Dim pc = it.Current
            c = 2.0 * b * x - a
            retval += pc * c
            a = b
            b = c
        End While
        Return retval
    End Function

    Function ChebEval(coef As List(Of Double), domain As Tuple(Of Double, Double), x As Double) As Double
        Return ChebEval(coef, AffineRemap(domain, x, Tuple.Create(-1.0, 1.0)))
    End Function

    Sub Main()
        Dim N = 10
        Dim fApprox As New ChebyshevApprox(AddressOf Math.Cos, N, Tuple.Create(0.0, 1.0))
        Console.WriteLine("Coefficients: ")
        For Each c In fApprox.coeffs
            Console.WriteLine(vbTab + "{0: 0.00000000000000;-0.00000000000000;zero}", c)
        Next

        Console.WriteLine(vbNewLine + "Approximation:" + vbNewLine + "    x       func(x)        approx      diff")
        Dim nX = 20.0
        Dim min = 0.0
        Dim max = 1.0
        For i = 1 To nX
            Dim x = AffineRemap(Tuple.Create(0.0, nX), i, Tuple.Create(min, max))
            Dim f = Math.Cos(x)
            Dim approx = fApprox.Eval(x)
            Console.WriteLine("{0:0.000} {1:0.00000000000000} {2:0.00000000000000} {3:E}", x, f, approx, approx - f)
        Next
    End Sub

End Module
