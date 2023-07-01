Imports System.Text

Module Module1
    Sub Main()
        Dim a As New BalancedTernary("+-0++0+")
        Console.WriteLine("a: {0} = {1}", a, a.ToLong)
        Dim b As New BalancedTernary(-436)
        Console.WriteLine("b: {0} = {1}", b, b.ToLong)
        Dim c As New BalancedTernary("+-++-")
        Console.WriteLine("c: {0} = {1}", c, c.ToLong)
        Dim d = a * (b - c)
        Console.WriteLine("a * (b - c): {0} = {1}", d, d.ToLong)
    End Sub

    Class BalancedTernary
        Private Enum BalancedTernaryDigit
            MINUS = -1
            ZERO = 0
            PLUS = 1
        End Enum

        Private ReadOnly value() As BalancedTernaryDigit

        ' empty = 0
        Public Sub New()
            ReDim value(-1)
        End Sub

        ' create from string
        Public Sub New(str As String)
            ReDim value(str.Length - 1)
            For i = 1 To str.Length
                If str(i - 1) = "-" Then
                    value(i - 1) = BalancedTernaryDigit.MINUS
                ElseIf str(i - 1) = "0" Then
                    value(i - 1) = BalancedTernaryDigit.ZERO
                ElseIf str(i - 1) = "+" Then
                    value(i - 1) = BalancedTernaryDigit.PLUS
                Else
                    Throw New ArgumentException("Unknown Digit: " + str(i - 1))
                End If
            Next
            Array.Reverse(value)
        End Sub

        ' convert integer
        Public Sub New(l As Long)
            Dim value As New List(Of BalancedTernaryDigit)
            Dim sign = Math.Sign(l)
            l = Math.Abs(l)

            While l <> 0
                Dim remainder = CType(l Mod 3, Byte)
                If remainder = 0 OrElse remainder = 1 Then
                    value.Add(remainder)
                    l /= 3
                ElseIf remainder = 2 Then
                    value.Add(BalancedTernaryDigit.MINUS)
                    l = (l + 1) / 3
                End If
            End While

            Me.value = value.ToArray
            If sign < 0 Then
                Invert()
            End If
        End Sub

        ' copy constructor
        Public Sub New(origin As BalancedTernary)
            ReDim value(origin.value.Length - 1)
            Array.Copy(origin.value, value, origin.value.Length)
        End Sub

        ' only for internal use
        Private Sub New(value() As BalancedTernaryDigit)
            Dim endi = value.Length - 1
            While endi > 0 AndAlso value(endi) = BalancedTernaryDigit.ZERO
                endi -= 1
            End While
            ReDim Me.value(endi)
            Array.Copy(value, Me.value, endi + 1)
        End Sub

        ' invert the values
        Private Sub Invert()
            For i = 1 To value.Length
                value(i - 1) = CType(-CType(value(i - 1), Integer), BalancedTernaryDigit)
            Next
        End Sub

        ' convert to string
        Public Overrides Function ToString() As String
            Dim result As New StringBuilder
            Dim i = value.Length - 1
            While i >= 0
                If value(i) = BalancedTernaryDigit.MINUS Then
                    result.Append("-")
                ElseIf value(i) = BalancedTernaryDigit.ZERO Then
                    result.Append("0")
                ElseIf value(i) = BalancedTernaryDigit.PLUS Then
                    result.Append("+")
                End If

                i -= 1
            End While
            Return result.ToString
        End Function

        ' convert to long
        Public Function ToLong() As Long
            Dim result = 0L
            For i = 1 To value.Length
                result += value(i - 1) * Math.Pow(3.0, i - 1)
            Next
            Return result
        End Function

        ' unary minus
        Public Shared Operator -(origin As BalancedTernary) As BalancedTernary
            Dim result As New BalancedTernary(origin)
            result.Invert()
            Return result
        End Operator

        ' addition of digits
        Private Shared carry = BalancedTernaryDigit.ZERO
        Private Shared Function Add(a As BalancedTernaryDigit, b As BalancedTernaryDigit) As BalancedTernaryDigit
            If a <> b Then
                carry = BalancedTernaryDigit.ZERO
                Return a + b
            Else
                carry = a
                Return -CType(b, Integer)
            End If
        End Function

        ' addition of balanced ternary numbers
        Public Shared Operator +(a As BalancedTernary, b As BalancedTernary) As BalancedTernary
            Dim maxLength = Math.Max(a.value.Length, b.value.Length)
            Dim resultValue(maxLength) As BalancedTernaryDigit
            For i = 1 To maxLength
                If i - 1 < a.value.Length Then
                    resultValue(i - 1) = Add(resultValue(i - 1), a.value(i - 1))
                    resultValue(i) = carry
                Else
                    carry = BalancedTernaryDigit.ZERO
                End If

                If i - 1 < b.value.Length Then
                    resultValue(i - 1) = Add(resultValue(i - 1), b.value(i - 1))
                    resultValue(i) = Add(resultValue(i), carry)
                End If
            Next
            Return New BalancedTernary(resultValue)
        End Operator

        ' subtraction of balanced ternary numbers
        Public Shared Operator -(a As BalancedTernary, b As BalancedTernary) As BalancedTernary
            Return a + (-b)
        End Operator

        ' multiplication of balanced ternary numbers
        Public Shared Operator *(a As BalancedTernary, b As BalancedTernary) As BalancedTernary
            Dim longValue = a.value
            Dim shortValue = b.value
            Dim result As New BalancedTernary

            If a.value.Length < b.value.Length Then
                longValue = b.value
                shortValue = a.value
            End If

            For i = 1 To shortValue.Length
                If shortValue(i - 1) <> BalancedTernaryDigit.ZERO Then
                    Dim temp(i + longValue.Length - 2) As BalancedTernaryDigit
                    For j = 1 To longValue.Length
                        temp(i + j - 2) = CType(shortValue(i - 1) * longValue(j - 1), BalancedTernaryDigit)
                    Next
                    result += New BalancedTernary(temp)
                End If
            Next

            Return result
        End Operator
    End Class

End Module
