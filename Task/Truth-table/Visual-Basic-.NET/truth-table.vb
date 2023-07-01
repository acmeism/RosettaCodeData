Imports System.Text

Module Module1
    Structure Operator_
        Public ReadOnly Symbol As Char
        Public ReadOnly Precedence As Integer
        Public ReadOnly Arity As Integer
        Public ReadOnly Fun As Func(Of Boolean, Boolean, Boolean)

        Public Sub New(symbol As Char, precedence As Integer, f As Func(Of Boolean, Boolean))
            Me.New(symbol, precedence, 1, Function(l, r) f(r))
        End Sub

        Public Sub New(symbol As Char, precedence As Integer, f As Func(Of Boolean, Boolean, Boolean))
            Me.New(symbol, precedence, 2, f)
        End Sub

        Public Sub New(symbol As Char, precedence As Integer, arity As Integer, fun As Func(Of Boolean, Boolean, Boolean))
            Me.Symbol = symbol
            Me.Precedence = precedence
            Me.Arity = arity
            Me.Fun = fun
        End Sub
    End Structure

    Public Class OperatorCollection
        Implements IEnumerable(Of Operator_)

        ReadOnly operators As IDictionary(Of Char, Operator_)

        Public Sub New(operators As IDictionary(Of Char, Operator_))
            Me.operators = operators
        End Sub

        Public Sub Add(symbol As Char, precedence As Integer, fun As Func(Of Boolean, Boolean))
            operators.Add(symbol, New Operator_(symbol, precedence, fun))
        End Sub
        Public Sub Add(symbol As Char, precedence As Integer, fun As Func(Of Boolean, Boolean, Boolean))
            operators.Add(symbol, New Operator_(symbol, precedence, fun))
        End Sub

        Public Sub Remove(symbol As Char)
            operators.Remove(symbol)
        End Sub

        Public Function GetEnumerator() As IEnumerator(Of Operator_) Implements IEnumerable(Of Operator_).GetEnumerator
            Return operators.Values.GetEnumerator
        End Function

        Private Function IEnumerable_GetEnumerator() As IEnumerator Implements IEnumerable.GetEnumerator
            Return GetEnumerator()
        End Function
    End Class

    Structure BitSet
        Private ReadOnly bits As Integer

        Public Sub New(bits As Integer)
            Me.bits = bits
        End Sub

        Public Shared Operator +(bs As BitSet, v As Integer) As BitSet
            Return New BitSet(bs.bits + v)
        End Operator

        Default Public ReadOnly Property Test(index As Integer) As Boolean
            Get
                Return (bits And (1 << index)) <> 0
            End Get
        End Property
    End Structure

    Public Class TruthTable
        Enum TokenType
            Unknown
            WhiteSpace
            Constant
            Operand
            Operator_
            LeftParenthesis
            RightParenthesis
        End Enum

        ReadOnly falseConstant As Char
        ReadOnly trueConstant As Char
        ReadOnly operatorDict As New Dictionary(Of Char, Operator_)

        Public ReadOnly Operators As OperatorCollection

        Sub New(falseConstant As Char, trueConstant As Char)
            Me.falseConstant = falseConstant
            Me.trueConstant = trueConstant
            Operators = New OperatorCollection(operatorDict)
        End Sub

        Private Function TypeOfToken(c As Char) As TokenType
            If Char.IsWhiteSpace(c) Then
                Return TokenType.WhiteSpace
            End If
            If c = "("c Then
                Return TokenType.LeftParenthesis
            End If
            If c = ")"c Then
                Return TokenType.RightParenthesis
            End If
            If c = trueConstant OrElse c = falseConstant Then
                Return TokenType.Constant
            End If
            If operatorDict.ContainsKey(c) Then
                Return TokenType.Operator_
            End If
            If Char.IsLetter(c) Then
                Return TokenType.Operand
            End If

            Return TokenType.Unknown
        End Function

        Private Function Precedence(op As Char) As Integer
            Dim o As New Operator_
            If operatorDict.TryGetValue(op, o) Then
                Return o.Precedence
            Else
                Return Integer.MinValue
            End If
        End Function

        Public Function ConvertToPostfix(infix As String) As String
            Dim stack As New Stack(Of Char)
            Dim postfix As New StringBuilder()
            For Each c In infix
                Dim type = TypeOfToken(c)
                Select Case type
                    Case TokenType.WhiteSpace
                        Continue For
                    Case TokenType.Constant, TokenType.Operand
                        postfix.Append(c)
                    Case TokenType.Operator_
                        Dim precedence_ = Precedence(c)
                        While stack.Count > 0 AndAlso Precedence(stack.Peek()) > precedence_
                            postfix.Append(stack.Pop())
                        End While
                        stack.Push(c)
                    Case TokenType.LeftParenthesis
                        stack.Push(c)
                    Case TokenType.RightParenthesis
                        Dim top As Char
                        While stack.Count > 0
                            top = stack.Pop()
                            If top = "("c Then
                                Exit While
                            Else
                                postfix.Append(top)
                            End If
                        End While
                        If top <> "("c Then
                            Throw New ArgumentException("No matching left parenthesis.")
                        End If
                    Case Else
                        Throw New ArgumentException("Invalid character: " + c)
                End Select
            Next
            While stack.Count > 0
                Dim top = stack.Pop()
                If top = "("c Then
                    Throw New ArgumentException("No matching right parenthesis.")
                End If
                postfix.Append(top)
            End While
            Return postfix.ToString
        End Function

        Private Function Evaluate(expression As Stack(Of Char), values As BitSet, parameters As IDictionary(Of Char, Integer)) As Boolean
            If expression.Count = 0 Then
                Throw New ArgumentException("Invalid expression.")
            End If
            Dim c = expression.Pop()
            Dim type = TypeOfToken(c)
            While type = TokenType.WhiteSpace
                c = expression.Pop()
                type = TypeOfToken(c)
            End While
            Select Case type
                Case TokenType.Constant
                    Return c = trueConstant
                Case TokenType.Operand
                    Return values(parameters(c))
                Case TokenType.Operator_
                    Dim right = Evaluate(expression, values, parameters)
                    Dim op = operatorDict(c)
                    If op.Arity = 1 Then
                        Return op.Fun(right, right)
                    End If

                    Dim left = Evaluate(expression, values, parameters)
                    Return op.Fun(left, right)
                Case Else
                    Throw New ArgumentException("Invalid character: " + c)
            End Select

            Return False
        End Function

        Public Iterator Function GetTruthTable(expression As String, Optional isPostfix As Boolean = False) As IEnumerable(Of String)
            If String.IsNullOrWhiteSpace(expression) Then
                Throw New ArgumentException("Invalid expression.")
            End If
            REM Maps parameters to an index in BitSet
            REM Makes sure they appear in the truth table in the order they first appear in the expression
            Dim parameters = expression _
                .Where(Function(c) TypeOfToken(c) = TokenType.Operand) _
                .Distinct() _
                .Reverse() _
                .Select(Function(c, i) Tuple.Create(c, i)) _
                .ToDictionary(Function(p) p.Item1, Function(p) p.Item2)

            Dim count = parameters.Count
            If count > 32 Then
                Throw New ArgumentException("Cannot have more than 32 parameters.")
            End If
            Dim header = If(count = 0, expression, String.Join(" ", parameters.OrderByDescending(Function(p) p.Value).Select(Function(p) p.Key)) & " " & expression)
            If Not isPostfix Then
                expression = ConvertToPostfix(expression)
            End If

            Dim values As BitSet
            Dim stack As New Stack(Of Char)(expression.Length)

            Dim loopy = 1 << count
            While loopy > 0
                For Each token In expression
                    stack.Push(token)
                Next
                Dim result = Evaluate(stack, values, parameters)
                If Not IsNothing(header) Then
                    If stack.Count > 0 Then
                        Throw New ArgumentException("Invalid expression.")
                    End If
                    Yield header
                    header = Nothing
                End If

                Dim line = If(count = 0, "", " ") + If(result, trueConstant, falseConstant)
                line = String.Join(" ", Enumerable.Range(0, count).Select(Function(i) If(values(count - i - 1), trueConstant, falseConstant))) + line
                Yield line
                values += 1
                ''''''''''''''''''''''''''''
                loopy -= 1
            End While
        End Function

        Public Sub PrintTruthTable(expression As String, Optional isPostfix As Boolean = False)
            Try
                For Each line In GetTruthTable(expression, isPostfix)
                    Console.WriteLine(line)
                Next
            Catch ex As ArgumentException
                Console.WriteLine(expression + "   " + ex.Message)
            End Try
        End Sub
    End Class

    Sub Main()
        Dim tt As New TruthTable("F"c, "T"c)
        tt.Operators.Add("!"c, 6, Function(r) Not r)
        tt.Operators.Add("&"c, 5, Function(l, r) l And r)
        tt.Operators.Add("^"c, 4, Function(l, r) l Xor r)
        tt.Operators.Add("|"c, 3, Function(l, r) l Or r)
        REM add a crazy operator
        Dim rng As New Random
        tt.Operators.Add("?"c, 6, Function(r) rng.NextDouble() < 0.5)
        Dim expressions() = {
            "!!!T",
            "?T",
            "F & x | T",
            "F & (x | T",
            "F & x | T)",
            "a ! (a & a)",
            "a | (a * a)",
            "a ^ T & (b & !c)"
        }
        For Each expression In expressions
            tt.PrintTruthTable(expression)
            Console.WriteLine()
        Next

        REM Define a different language
        tt = New TruthTable("0"c, "1"c)
        tt.Operators.Add("-"c, 6, Function(r) Not r)
        tt.Operators.Add("^"c, 5, Function(l, r) l And r)
        tt.Operators.Add("v"c, 3, Function(l, r) l Or r)
        tt.Operators.Add(">"c, 2, Function(l, r) Not l Or r)
        tt.Operators.Add("="c, 1, Function(l, r) l = r)
        expressions = {
            "-X v 0 = X ^ 1",
            "(H > M) ^ (S > H) > (S > M)"
        }
        For Each expression In expressions
            tt.PrintTruthTable(expression)
            Console.WriteLine()
        Next
    End Sub

End Module
