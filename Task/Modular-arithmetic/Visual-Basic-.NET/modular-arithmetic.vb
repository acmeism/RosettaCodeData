Module Module1

    Interface IAddition(Of T)
        Function Add(rhs As T) As T
    End Interface

    Interface IMultiplication(Of T)
        Function Multiply(rhs As T) As T
    End Interface

    Interface IPower(Of T)
        Function Power(pow As Integer) As T
    End Interface

    Interface IOne(Of T)
        Function One() As T
    End Interface

    Class ModInt
        Implements IAddition(Of ModInt), IMultiplication(Of ModInt), IPower(Of ModInt), IOne(Of ModInt)

        Sub New(value As Integer, modulo As Integer)
            Me.Value = value
            Me.Modulo = modulo
        End Sub

        ReadOnly Property Value As Integer
        ReadOnly Property Modulo As Integer

        Public Function Add(rhs As ModInt) As ModInt Implements IAddition(Of ModInt).Add
            Return Me + rhs
        End Function

        Public Function Multiply(rhs As ModInt) As ModInt Implements IMultiplication(Of ModInt).Multiply
            Return Me * rhs
        End Function

        Public Function Power(pow_ As Integer) As ModInt Implements IPower(Of ModInt).Power
            Return Pow(Me, pow_)
        End Function

        Public Function One() As ModInt Implements IOne(Of ModInt).One
            Return New ModInt(1, Modulo)
        End Function

        Public Overrides Function ToString() As String
            Return String.Format("ModInt({0}, {1})", Value, Modulo)
        End Function

        Public Shared Operator +(lhs As ModInt, rhs As ModInt) As ModInt
            If lhs.Modulo <> rhs.Modulo Then
                Throw New ArgumentException("Cannot add rings with different modulus")
            End If
            Return New ModInt((lhs.Value + rhs.Value) Mod lhs.Modulo, lhs.Modulo)
        End Operator

        Public Shared Operator *(lhs As ModInt, rhs As ModInt) As ModInt
            If lhs.Modulo <> rhs.Modulo Then
                Throw New ArgumentException("Cannot multiply rings with different modulus")
            End If
            Return New ModInt((lhs.Value * rhs.Value) Mod lhs.Modulo, lhs.Modulo)
        End Operator

        Public Shared Function Pow(self As ModInt, p As Integer) As ModInt
            If p < 0 Then
                Throw New ArgumentException("p must be zero or greater")
            End If

            Dim pp = p
            Dim pwr = self.One()
            While pp > 0
                pp -= 1
                pwr *= self
            End While
            Return pwr
        End Function
    End Class

    Function F(Of T As {IAddition(Of T), IMultiplication(Of T), IPower(Of T), IOne(Of T)})(x As T) As T
        Return x.Power(100).Add(x).Add(x.One)
    End Function

    Sub Main()
        Dim x As New ModInt(10, 13)
        Dim y = F(x)
        Console.WriteLine("x ^ 100 + x + 1 for x = {0} is {1}", x, y)
    End Sub

End Module
