Option Strict On

Imports System.Text.RegularExpressions

Module Module1

    Class Operator_
        Sub New(t As Char, p As Integer, Optional i As Boolean = False)
            Token = t
            Precedence = p
            IsRightAssociative = i
        End Sub

        Property Token As Char
            Get
                Return m_token
            End Get
            Private Set(value As Char)
                m_token = value
            End Set
        End Property

        Property Precedence As Integer
            Get
                Return m_precedence
            End Get
            Private Set(value As Integer)
                m_precedence = value
            End Set
        End Property

        Property IsRightAssociative As Boolean
            Get
                Return m_right
            End Get
            Private Set(value As Boolean)
                m_right = value
            End Set
        End Property

        Private m_token As Char
        Private m_precedence As Integer
        Private m_right As Boolean
    End Class

    ReadOnly operators As New Dictionary(Of Char, Operator_) From {
        {"+"c, New Operator_("+"c, 2)},
        {"-"c, New Operator_("-"c, 2)},
        {"/"c, New Operator_("/"c, 3)},
        {"*"c, New Operator_("*"c, 3)},
        {"^"c, New Operator_("^"c, 4, True)}
    }

    Class Expression
        Public Sub New(e As String)
            Ex = e
        End Sub

        Sub New(e1 As String, e2 As String, o As Operator_)
            Ex = String.Format("{0} {1} {2}", e1, o.Token, e2)
            Op = o
        End Sub

        ReadOnly Property Ex As String
        ReadOnly Property Op As Operator_
    End Class

    Function PostfixToInfix(postfix As String) As String
        Dim stack As New Stack(Of Expression)

        For Each token As String In Regex.Split(postfix, "\s+")
            Dim c = token(0)
            Dim op = operators.FirstOrDefault(Function(kv) kv.Key = c).Value
            If Not IsNothing(op) AndAlso token.Length = 1 Then
                Dim rhs = stack.Pop()
                Dim lhs = stack.Pop()

                Dim opPrec = op.Precedence

                Dim lhsPrec = If(IsNothing(lhs.Op), Integer.MaxValue, lhs.Op.Precedence)
                Dim rhsPrec = If(IsNothing(rhs.Op), Integer.MaxValue, rhs.Op.Precedence)

                Dim newLhs As String
                If lhsPrec < opPrec OrElse (lhsPrec = opPrec AndAlso c = "^") Then
                    'lhs.Ex = "(" + lhs.Ex + ")"
                    newLhs = "(" + lhs.Ex + ")"
                Else
                    newLhs = lhs.Ex
                End If

                Dim newRhs As String
                If rhsPrec < opPrec OrElse (rhsPrec = opPrec AndAlso c <> "^") Then
                    'rhs.Ex = "(" + rhs.Ex + ")"
                    newRhs = "(" + rhs.Ex + ")"
                Else
                    newRhs = rhs.Ex
                End If

                stack.Push(New Expression(newLhs, newRhs, op))
            Else
                stack.Push(New Expression(token))
            End If

            'Print intermediate result
            Console.WriteLine("{0} -> [{1}]", token, String.Join(", ", stack.Reverse().Select(Function(e) e.Ex)))
        Next

        Return stack.Peek().Ex
    End Function

    Sub Main()
        Dim inputs = {"3 4 2 * 1 5 - 2 3 ^ ^ / +", "1 2 + 3 4 + ^ 5 6 + ^"}
        For Each e In inputs
            Console.WriteLine("Postfix : {0}", e)
            Console.WriteLine("Infix : {0}", PostfixToInfix(e))
            Console.WriteLine()
        Next
        Console.ReadLine() 'remove before submit
    End Sub

End Module
