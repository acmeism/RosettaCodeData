Module Module1

    Class Frac
        Private ReadOnly num As Long
        Private ReadOnly denom As Long

        Public Shared ReadOnly ZERO = New Frac(0, 1)
        Public Shared ReadOnly ONE = New Frac(1, 1)

        Public Sub New(n As Long, d As Long)
            If d = 0 Then
                Throw New ArgumentException("d must not be zero")
            End If
            Dim nn = n
            Dim dd = d
            If nn = 0 Then
                dd = 1
            ElseIf dd < 0 Then
                nn = -nn
                dd = -dd
            End If
            Dim g = Math.Abs(Gcd(nn, dd))
            If g > 1 Then
                nn /= g
                dd /= g
            End If
            num = nn
            denom = dd
        End Sub

        Private Shared Function Gcd(a As Long, b As Long) As Long
            If b = 0 Then
                Return a
            Else
                Return Gcd(b, a Mod b)
            End If
        End Function

        Public Shared Operator -(self As Frac) As Frac
            Return New Frac(-self.num, self.denom)
        End Operator

        Public Shared Operator +(lhs As Frac, rhs As Frac) As Frac
            Return New Frac(lhs.num * rhs.denom + lhs.denom * rhs.num, rhs.denom * lhs.denom)
        End Operator

        Public Shared Operator -(lhs As Frac, rhs As Frac) As Frac
            Return lhs + -rhs
        End Operator

        Public Shared Operator *(lhs As Frac, rhs As Frac) As Frac
            Return New Frac(lhs.num * rhs.num, lhs.denom * rhs.denom)
        End Operator

        Public Shared Operator <(lhs As Frac, rhs As Frac) As Boolean
            Dim x = lhs.num / lhs.denom
            Dim y = rhs.num / rhs.denom
            Return x < y
        End Operator

        Public Shared Operator >(lhs As Frac, rhs As Frac) As Boolean
            Dim x = lhs.num / lhs.denom
            Dim y = rhs.num / rhs.denom
            Return x > y
        End Operator

        Public Shared Operator =(lhs As Frac, rhs As Frac) As Boolean
            Return lhs.num = rhs.num AndAlso lhs.denom = rhs.denom
        End Operator

        Public Shared Operator <>(lhs As Frac, rhs As Frac) As Boolean
            Return lhs.num <> rhs.num OrElse lhs.denom <> rhs.denom
        End Operator

        Public Overrides Function ToString() As String
            If denom = 1 Then
                Return num.ToString
            Else
                Return String.Format("{0}/{1}", num, denom)
            End If
        End Function

        Public Overrides Function Equals(obj As Object) As Boolean
            Dim frac = CType(obj, Frac)
            Return Not IsNothing(frac) AndAlso num = frac.num AndAlso denom = frac.denom
        End Function
    End Class

    Function Bernoulli(n As Integer) As Frac
        If n < 0 Then
            Throw New ArgumentException("n may not be negative or zero")
        End If
        Dim a(n + 1) As Frac
        For m = 0 To n
            a(m) = New Frac(1, m + 1)
            For j = m To 1 Step -1
                a(j - 1) = (a(j - 1) - a(j)) * New Frac(j, 1)
            Next
        Next
        ' returns 'first' Bernoulli number
        If n <> 1 Then
            Return a(0)
        Else
            Return -a(0)
        End If
    End Function

    Function Binomial(n As Integer, k As Integer) As Integer
        If n < 0 OrElse k < 0 OrElse n < k Then
            Throw New ArgumentException()
        End If
        If n = 0 OrElse k = 0 Then
            Return 1
        End If
        Dim num = 1
        For i = k + 1 To n
            num *= i
        Next
        Dim denom = 1
        For i = 2 To n - k
            denom *= i
        Next
        Return num \ denom
    End Function

    Function FaulhaberTriangle(p As Integer) As Frac()
        Dim coeffs(p + 1) As Frac
        For i = 1 To p + 1
            coeffs(i - 1) = Frac.ZERO
        Next
        Dim q As New Frac(1, p + 1)
        Dim sign = -1
        For j = 0 To p
            sign *= -1
            coeffs(p - j) = q * New Frac(sign, 1) * New Frac(Binomial(p + 1, j), 1) * Bernoulli(j)
        Next
        Return coeffs
    End Function

    Sub Main()
        For i = 1 To 10
            Dim coeffs = FaulhaberTriangle(i - 1)
            For Each coeff In coeffs
                Console.Write("{0,5}  ", coeff)
            Next
            Console.WriteLine()
        Next
    End Sub

End Module
