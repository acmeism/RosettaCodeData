Module Module1
    Function Gcd(a As Long, b As Long)
        If b = 0 Then
            Return a
        End If
        Return Gcd(b, a Mod b)
    End Function

    Class Frac
        ReadOnly num As Long
        ReadOnly denom As Long

        Public Shared ReadOnly ZERO As New Frac(0, 1)
        Public Shared ReadOnly ONE As New Frac(1, 1)

        Public Sub New(n As Long, d As Long)
            If d = 0 Then Throw New ArgumentException("d must not be zero")
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

        Public Overloads Function Equals(obj As Object) As Boolean
            Dim frac = CType(obj, Frac)
            Return Not IsNothing(frac) AndAlso num = frac.num AndAlso denom = frac.denom
        End Function

        Public Overloads Function GetHashCode() As Integer
            Dim hashCode = 1317992671
            hashCode = hashCode * -1521134295 + num.GetHashCode()
            hashCode = hashCode * -1521134295 + denom.GetHashCode()
            Return hashCode
        End Function

        Public Overloads Function ToString() As String
            If denom = 1 Then Return num.ToString()
            Return String.Format("{0}/{1}", num, denom)
        End Function
    End Class

    Function Bernoulli(n As Integer) As Frac
        If n < 0 Then Throw New ArgumentException("n may not be negative or zero")
        Dim a(n + 1) As Frac
        For m = 0 To n
            a(m) = New Frac(1, m + 1)
            For j = m To 1 Step -1
                a(j - 1) = (a(j - 1) - a(j)) * New Frac(j, 1)
            Next
        Next
        'returns the first Bernoulli number
        If n <> 1 Then Return a(0)
        Return -a(0)
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
        Return num / denom
    End Function

    Sub Faulhaber(p As Integer)
        Console.Write("{0} : ", p)
        Dim q As New Frac(1, p + 1)
        Dim sign = -1
        For j = 0 To p
            sign *= -1
            Dim coeff = q * New Frac(sign, 1) * New Frac(Binomial(p + 1, j), 1) * Bernoulli(j)
            If Frac.ZERO = coeff Then Continue For
            If j = 0 Then
                If Frac.ONE <> coeff Then
                    If -Frac.ONE = coeff Then
                        Console.Write("-")
                    Else
                        Console.Write(coeff.ToString())
                    End If
                End If
            Else
                If Frac.ONE = coeff Then
                    Console.Write(" + ")
                ElseIf -Frac.ONE = coeff Then
                    Console.Write(" - ")
                ElseIf Frac.ZERO < coeff Then
                    Console.Write(" + {0}", coeff.ToString())
                Else
                    Console.Write(" - {0}", (-coeff).ToString())
                End If
            End If
            Dim pwr = p + 1 - j
            If pwr > 1 Then
                Console.Write("n^{0}", pwr)
            Else
                Console.Write("n")
            End If
        Next
        Console.WriteLine()
    End Sub

    Sub Main()
        For i = 0 To 9
            Faulhaber(i)
        Next
    End Sub
End Module
