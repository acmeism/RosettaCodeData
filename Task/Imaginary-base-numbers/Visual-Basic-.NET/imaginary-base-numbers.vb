Imports System.Text

Module Module1

    Class Complex : Implements IFormattable
        Private ReadOnly real As Double
        Private ReadOnly imag As Double

        Public Sub New(r As Double, i As Double)
            real = r
            imag = i
        End Sub

        Public Sub New(r As Integer, i As Integer)
            real = r
            imag = i
        End Sub

        Public Function Inv() As Complex
            Dim denom = real * real + imag * imag
            Return New Complex(real / denom, -imag / denom)
        End Function

        Public Shared Operator -(self As Complex) As Complex
            Return New Complex(-self.real, -self.imag)
        End Operator

        Public Shared Operator +(lhs As Complex, rhs As Complex) As Complex
            Return New Complex(lhs.real + rhs.real, lhs.imag + rhs.imag)
        End Operator

        Public Shared Operator -(lhs As Complex, rhs As Complex) As Complex
            Return New Complex(lhs.real - rhs.real, lhs.imag - rhs.imag)
        End Operator

        Public Shared Operator *(lhs As Complex, rhs As Complex) As Complex
            Return New Complex(lhs.real * rhs.real - lhs.imag * rhs.imag, lhs.real * rhs.imag + lhs.imag * rhs.real)
        End Operator

        Public Shared Operator /(lhs As Complex, rhs As Complex) As Complex
            Return lhs * rhs.Inv
        End Operator

        Public Shared Operator *(lhs As Complex, rhs As Double) As Complex
            Return New Complex(lhs.real * rhs, lhs.imag * rhs)
        End Operator

        Public Function ToQuaterImaginary() As QuaterImaginary
            If real = 0.0 AndAlso imag = 0.0 Then
                Return New QuaterImaginary("0")
            End If
            Dim re = CType(real, Integer)
            Dim im = CType(imag, Integer)
            Dim fi = -1
            Dim sb As New StringBuilder
            While re <> 0
                Dim rm = re Mod -4
                re \= -4
                If rm < 0 Then
                    rm += 4
                    re += 1
                End If
                sb.Append(rm)
                sb.Append(0)
            End While
            If im <> 0 Then
                Dim f = (New Complex(0.0, imag) / New Complex(0.0, 2.0)).real
                im = Math.Ceiling(f)
                f = -4.0 * (f - im)
                Dim index = 1
                While im <> 0
                    Dim rm = im Mod -4
                    im \= -4
                    If rm < 0 Then
                        rm += 4
                        im += 1
                    End If
                    If index < sb.Length Then
                        sb(index) = Chr(rm + 48)
                    Else
                        sb.Append(0)
                        sb.Append(rm)
                    End If
                    index += 2
                End While
                fi = f
            End If
            Dim reverse As New String(sb.ToString().Reverse().ToArray())
            sb.Length = 0
            sb.Append(reverse)
            If fi <> -1 Then
                sb.AppendFormat(".{0}", fi)
            End If
            Dim s = sb.ToString().TrimStart("0")
            If s(0) = "." Then
                s = "0" + s
            End If
            Return New QuaterImaginary(s)
        End Function

        Public Overloads Function ToString() As String
            Dim r2 = If(real = -0.0, 0.0, real) 'get rid of negative zero
            Dim i2 = If(imag = -0.0, 0.0, imag) 'ditto
            If i2 = 0.0 Then
                Return String.Format("{0}", r2)
            End If
            If r2 = 0.0 Then
                Return String.Format("{0}i", i2)
            End If
            If i2 > 0.0 Then
                Return String.Format("{0} + {1}i", r2, i2)
            End If
            Return String.Format("{0} - {1}i", r2, -i2)
        End Function

        Public Overloads Function ToString(format As String, formatProvider As IFormatProvider) As String Implements IFormattable.ToString
            Return ToString()
        End Function
    End Class

    Class QuaterImaginary
        Private Shared ReadOnly twoI = New Complex(0.0, 2.0)
        Private Shared ReadOnly invTwoI = twoI.Inv()

        Private ReadOnly b2i As String

        Public Sub New(b2i As String)
            If b2i = "" OrElse Not b2i.All(Function(c) "0123.".IndexOf(c) > -1) OrElse b2i.Count(Function(c) c = ".") > 1 Then
                Throw New Exception("Invalid Base 2i number")
            End If
            Me.b2i = b2i
        End Sub

        Public Function ToComplex() As Complex
            Dim pointPos = b2i.IndexOf(".")
            Dim posLen = If(pointPos <> -1, pointPos, b2i.Length)
            Dim sum = New Complex(0.0, 0.0)
            Dim prod = New Complex(1.0, 0.0)
            For j = 0 To posLen - 1
                Dim k = Asc(b2i(posLen - 1 - j)) - Asc("0")
                If k > 0.0 Then
                    sum += prod * k
                End If
                prod *= twoI
            Next
            If pointPos <> -1 Then
                prod = invTwoI
                For j = posLen + 1 To b2i.Length - 1
                    Dim k = Asc(b2i(j)) - Asc("0")
                    If k > 0.0 Then
                        sum += prod * k
                    End If
                    prod *= invTwoI
                Next
            End If
            Return sum
        End Function

        Public Overrides Function ToString() As String
            Return b2i
        End Function
    End Class

    Sub Main()
        For i = 1 To 16
            Dim c1 As New Complex(i, 0)
            Dim qi = c1.ToQuaterImaginary()
            Dim c2 = qi.ToComplex()
            Console.Write("{0,4} -> {1,8} -> {2,4}     ", c1, qi, c2)
            c1 = -c1
            qi = c1.ToQuaterImaginary()
            c2 = qi.ToComplex()
            Console.WriteLine("{0,4} -> {1,8} -> {2,4}", c1, qi, c2)
        Next
        Console.WriteLine()
        For i = 1 To 16
            Dim c1 As New Complex(0, i)
            Dim qi = c1.ToQuaterImaginary()
            Dim c2 = qi.ToComplex()
            Console.Write("{0,4} -> {1,8} -> {2,4}     ", c1, qi, c2)
            c1 = -c1
            qi = c1.ToQuaterImaginary()
            c2 = qi.ToComplex()
            Console.WriteLine("{0,4} -> {1,8} -> {2,4}", c1, qi, c2)
        Next
    End Sub

End Module
