Module Module1
    Class SymbolType
        Public ReadOnly symbol As String
        Public ReadOnly precedence As Integer
        Public ReadOnly rightAssociative As Boolean

        Public Sub New(symbol As String, precedence As Integer, rightAssociative As Boolean)
            Me.symbol = symbol
            Me.precedence = precedence
            Me.rightAssociative = rightAssociative
        End Sub
    End Class

    ReadOnly Operators As Dictionary(Of String, SymbolType) = New Dictionary(Of String, SymbolType) From
    {
        {"^", New SymbolType("^", 4, True)},
        {"*", New SymbolType("*", 3, False)},
        {"/", New SymbolType("/", 3, False)},
        {"+", New SymbolType("+", 2, False)},
        {"-", New SymbolType("-", 2, False)}
    }

    Function ToPostfix(infix As String) As String
        Dim tokens = infix.Split(" ")
        Dim stack As New Stack(Of String)
        Dim output As New List(Of String)

        Dim Print = Sub(action As String) Console.WriteLine("{0,-4} {1,-18} {2}", action + ":", $"stack[ {String.Join(" ", stack.Reverse())} ]", $"out[ {String.Join(" ", output)} ]")

        For Each token In tokens
            Dim iv As Integer
            Dim op1 As SymbolType
            Dim op2 As SymbolType
            If Integer.TryParse(token, iv) Then
                output.Add(token)
                Print(token)
            ElseIf Operators.TryGetValue(token, op1) Then
                While stack.Count > 0 AndAlso Operators.TryGetValue(stack.Peek(), op2)
                    Dim c = op1.precedence.CompareTo(op2.precedence)
                    If c < 0 OrElse Not op1.rightAssociative AndAlso c <= 0 Then
                        output.Add(stack.Pop())
                    Else
                        Exit While
                    End If
                End While
                stack.Push(token)
                Print(token)
            ElseIf token = "(" Then
                stack.Push(token)
                Print(token)
            ElseIf token = ")" Then
                Dim top = ""
                While stack.Count > 0
                    top = stack.Pop()
                    If top <> "(" Then
                        output.Add(top)
                    Else
                        Exit While
                    End If
                End While
                If top <> "(" Then
                    Throw New ArgumentException("No matching left parenthesis.")
                End If
                Print(token)
            End If
        Next
        While stack.Count > 0
            Dim top = stack.Pop()
            If Not Operators.ContainsKey(top) Then
                Throw New ArgumentException("No matching right parenthesis.")
            End If
            output.Add(top)
        End While
        Print("pop")
        Return String.Join(" ", output)
    End Function

    Sub Main()
        Dim infix = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
        Console.WriteLine(ToPostfix(infix))
    End Sub

End Module
