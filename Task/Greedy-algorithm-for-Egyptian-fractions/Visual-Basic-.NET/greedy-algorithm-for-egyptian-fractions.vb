Imports System.Numerics
Imports System.Text

Module Module1

    Function Gcd(a As BigInteger, b As BigInteger) As BigInteger
        If b = 0 Then
            If a < 0 Then
                Return -a
            Else
                Return a
            End If
        Else
            Return Gcd(b, a Mod b)
        End If
    End Function

    Function Lcm(a As BigInteger, b As BigInteger) As BigInteger
        Return a / Gcd(a, b) * b
    End Function

    Public Class Rational
        Dim num As BigInteger
        Dim den As BigInteger

        Public Sub New(n As BigInteger, d As BigInteger)
            Dim c = Gcd(n, d)
            num = n / c
            den = d / c
            If den < 0 Then
                num = -num
                den = -den
            End If
        End Sub

        Public Sub New(n As BigInteger)
            num = n
            den = 1
        End Sub

        Public Function Numerator() As BigInteger
            Return num
        End Function

        Public Function Denominator() As BigInteger
            Return den
        End Function

        Public Overrides Function ToString() As String
            If den = 1 Then
                Return num.ToString()
            Else
                Return String.Format("{0}/{1}", num, den)
            End If
        End Function

        'Arithmetic operators
        Public Shared Operator +(lhs As Rational, rhs As Rational) As Rational
            Return New Rational(lhs.num * rhs.den + rhs.num * lhs.den, lhs.den * rhs.den)
        End Operator

        Public Shared Operator -(lhs As Rational, rhs As Rational) As Rational
            Return New Rational(lhs.num * rhs.den - rhs.num * lhs.den, lhs.den * rhs.den)
        End Operator

        'Comparison operators

        Public Shared Operator =(lhs As Rational, rhs As Rational) As Boolean
            Return lhs.num = rhs.num AndAlso lhs.den = rhs.den
        End Operator

        Public Shared Operator <>(lhs As Rational, rhs As Rational) As Boolean
            Return lhs.num <> rhs.num OrElse lhs.den <> rhs.den
        End Operator

        Public Shared Operator <(lhs As Rational, rhs As Rational) As Boolean
            'a/b < c/d
            'ad < bc
            Dim ad = lhs.num * rhs.den
            Dim bc = lhs.den * rhs.num
            Return ad < bc
        End Operator

        Public Shared Operator >(lhs As Rational, rhs As Rational) As Boolean
            'a/b > c/d
            'ad > bc
            Dim ad = lhs.num * rhs.den
            Dim bc = lhs.den * rhs.num
            Return ad > bc
        End Operator

        Public Shared Operator <=(lhs As Rational, rhs As Rational) As Boolean
            Return lhs < rhs OrElse lhs = rhs
        End Operator

        Public Shared Operator >=(lhs As Rational, rhs As Rational) As Boolean
            Return lhs > rhs OrElse lhs = rhs
        End Operator

        'Conversion operators
        Public Shared Widening Operator CType(ByVal bi As BigInteger) As Rational
            Return New Rational(bi)
        End Operator
        Public Shared Widening Operator CType(ByVal lo As Long) As Rational
            Return New Rational(lo)
        End Operator
    End Class

    Function Egyptian(r As Rational) As List(Of Rational)
        Dim result As New List(Of Rational)

        If r >= 1 Then
            If r.Denominator() = 1 Then
                result.Add(r)
                result.Add(New Rational(0))
                Return result
            End If
            result.Add(New Rational(r.Numerator / r.Denominator))
            r -= result(0)
        End If

        Dim modFunc = Function(m As BigInteger, n As BigInteger)
                          Return ((m Mod n) + n) Mod n
                      End Function

        While r.Numerator() <> 1
            Dim q = (r.Denominator() + r.Numerator() - 1) / r.Numerator()
            result.Add(New Rational(1, q))
            r = New Rational(modFunc(-r.Denominator(), r.Numerator()), r.Denominator * q)
        End While

        result.Add(r)
        Return result
    End Function

    Function FormatList(Of T)(col As List(Of T)) As String
        Dim iter = col.GetEnumerator()
        Dim sb As New StringBuilder

        sb.Append("[")
        If iter.MoveNext() Then
            sb.Append(iter.Current)
        End If
        While iter.MoveNext()
            sb.Append(", ")
            sb.Append(iter.Current)
        End While
        sb.Append("]")
        Return sb.ToString()
    End Function

    Sub Main()
        Dim rs = {New Rational(43, 48), New Rational(5, 121), New Rational(2014, 59)}
        For Each r In rs
            Console.WriteLine("{0} => {1}", r, FormatList(Egyptian(r)))
        Next

        Dim lenMax As Tuple(Of ULong, Rational) = Tuple.Create(0UL, New Rational(0))
        Dim denomMax As Tuple(Of BigInteger, Rational) = Tuple.Create(New BigInteger(0), New Rational(0))

        Dim query = (From i In Enumerable.Range(1, 100)
                     From j In Enumerable.Range(1, 100)
                     Select New Rational(i, j)).Distinct().ToList()
        For Each r In query
            Dim e = Egyptian(r)
            Dim eLen As ULong = e.Count
            Dim eDenom = e.Last().Denominator()
            If eLen > lenMax.Item1 Then
                lenMax = Tuple.Create(eLen, r)
            End If
            If eDenom > denomMax.Item1 Then
                denomMax = Tuple.Create(eDenom, r)
            End If
        Next

        Console.WriteLine("Term max is {0} with {1} terms", lenMax.Item2, lenMax.Item1)
        Dim dStr = denomMax.Item1.ToString()
        Console.WriteLine("Denominator max is {0} with {1} digits {2}...{3}", denomMax.Item2, dStr.Length, dStr.Substring(0, 5), dStr.Substring(dStr.Length - 5, 5))
    End Sub

End Module
