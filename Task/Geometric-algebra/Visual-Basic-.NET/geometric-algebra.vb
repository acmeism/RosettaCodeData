Option Strict On

Imports System.Text

Module Module1

    Structure Vector
        Private ReadOnly dims() As Double

        Public Sub New(da() As Double)
            dims = da
        End Sub

        Public Shared Operator -(v As Vector) As Vector
            Return v * -1.0
        End Operator

        Public Shared Operator +(lhs As Vector, rhs As Vector) As Vector
            Dim result(31) As Double
            Array.Copy(lhs.dims, 0, result, 0, lhs.Length)
            For i = 1 To result.Length
                Dim i2 = i - 1
                result(i2) = lhs(i2) + rhs(i2)
            Next
            Return New Vector(result)
        End Operator

        Public Shared Operator *(lhs As Vector, rhs As Vector) As Vector
            Dim result(31) As Double
            For i = 1 To lhs.Length
                Dim i2 = i - 1
                If lhs(i2) <> 0.0 Then
                    For j = 1 To lhs.Length
                        Dim j2 = j - 1
                        If rhs(j2) <> 0.0 Then
                            Dim s = ReorderingSign(i2, j2) * lhs(i2) * rhs(j2)
                            Dim k = i2 Xor j2
                            result(k) += s
                        End If
                    Next
                End If
            Next
            Return New Vector(result)
        End Operator

        Public Shared Operator *(v As Vector, scale As Double) As Vector
            Dim result = CType(v.dims.Clone, Double())
            For i = 1 To result.Length
                Dim i2 = i - 1
                result(i2) *= scale
            Next
            Return New Vector(result)
        End Operator

        Default Public Property Index(key As Integer) As Double
            Get
                Return dims(key)
            End Get
            Set(value As Double)
                dims(key) = value
            End Set
        End Property

        Public ReadOnly Property Length As Integer
            Get
                Return dims.Length
            End Get
        End Property

        Public Function Dot(rhs As Vector) As Vector
            Return (Me * rhs + rhs * Me) * 0.5
        End Function

        Private Shared Function BitCount(i As Integer) As Integer
            i -= ((i >> 1) And &H55555555)
            i = (i And &H33333333) + ((i >> 2) And &H33333333)
            i = (i + (i >> 4)) And &HF0F0F0F
            i += (i >> 8)
            i += (i >> 16)
            Return i And &H3F
        End Function

        Private Shared Function ReorderingSign(i As Integer, j As Integer) As Double
            Dim k = i >> 1
            Dim sum = 0
            While k <> 0
                sum += BitCount(k And j)
                k >>= 1
            End While
            Return If((sum And 1) = 0, 1.0, -1.0)
        End Function

        Public Overrides Function ToString() As String
            Dim it = dims.GetEnumerator

            Dim sb As New StringBuilder("[")
            If it.MoveNext() Then
                sb.Append(it.Current)
            End If
            While it.MoveNext
                sb.Append(", ")
                sb.Append(it.Current)
            End While
            sb.Append("]")
            Return sb.ToString
        End Function
    End Structure

    Function DoubleArray(size As Integer) As Double()
        Dim result(size - 1) As Double
        For i = 1 To size
            Dim i2 = i - 1
            result(i2) = 0.0
        Next
        Return result
    End Function

    Function E(n As Integer) As Vector
        If n > 4 Then
            Throw New ArgumentException("n must be less than 5")
        End If

        Dim result As New Vector(DoubleArray(32))
        result(1 << n) = 1.0
        Return result
    End Function

    ReadOnly r As New Random()

    Function RandomVector() As Vector
        Dim result As New Vector(DoubleArray(32))
        For i = 1 To 5
            Dim i2 = i - 1
            Dim singleton() As Double = {r.NextDouble()}
            result += New Vector(singleton) * E(i2)
        Next
        Return result
    End Function

    Function RandomMultiVector() As Vector
        Dim result As New Vector(DoubleArray(32))
        For i = 1 To result.Length
            Dim i2 = i - 1
            result(i2) = r.NextDouble()
        Next
        Return result
    End Function

    Sub Main()
        For i = 1 To 5
            Dim i2 = i - 1
            For j = 1 To 5
                Dim j2 = j - 1
                If i2 < j2 Then
                    If E(i2).Dot(E(j2))(0) <> 0.0 Then
                        Console.Error.WriteLine("Unexpected non-null scalar product")
                        Return
                    End If
                ElseIf i2 = j2 Then
                    If E(i2).Dot(E(j2))(0) = 0.0 Then
                        Console.Error.WriteLine("Unexpected null scalar product")
                        Return
                    End If
                End If
            Next
        Next

        Dim a = RandomMultiVector()
        Dim b = RandomMultiVector()
        Dim c = RandomMultiVector()
        Dim x = RandomVector()

        ' (ab)c == a(bc)
        Console.WriteLine((a * b) * c)
        Console.WriteLine(a * (b * c))
        Console.WriteLine()

        ' a(b+c) == ab + ac
        Console.WriteLine(a * (b + c))
        Console.WriteLine(a * b + a * c)
        Console.WriteLine()

        ' (a+b)c == ac + bc
        Console.WriteLine((a + b) * c)
        Console.WriteLine(a * c + b * c)
        Console.WriteLine()

        ' x^2 is real
        Console.WriteLine(x * x)
    End Sub

End Module
