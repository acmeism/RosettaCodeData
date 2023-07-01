Imports System.Runtime.CompilerServices

Module Module1

    <Extension()>
    Iterator Function Loopy(Of T)(seq As IEnumerable(Of T)) As IEnumerable(Of T)
        While True
            For Each element In seq
                Yield element
            Next
        End While
    End Function

    Iterator Function TurnWheels(ParamArray wheels As (name As Char, values As String)()) As IEnumerable(Of Char)
        Dim data = wheels.ToDictionary(Function(wheel) wheel.name, Function(wheel) wheel.values.Loopy.GetEnumerator)
        Dim primary = data(wheels(0).name)

        Dim Turn As Func(Of IEnumerator(Of Char), Char) = Function(sequence As IEnumerator(Of Char))
                                                              sequence.MoveNext()
                                                              Dim c = sequence.Current
                                                              Return If(Char.IsDigit(c), c, Turn(data(c)))
                                                          End Function

        While True
            Yield Turn(primary)
        End While
    End Function

    <Extension()>
    Sub Print(sequence As IEnumerable(Of Char))
        Console.WriteLine(String.Join(" ", sequence))
    End Sub

    Sub Main()
        TurnWheels(("A", "123")).Take(20).Print()
        TurnWheels(("A", "1B2"), ("B", "34")).Take(20).Print()
        TurnWheels(("A", "1DD"), ("D", "678")).Take(20).Print()
        TurnWheels(("A", "1BC"), ("B", "34"), ("C", "5B")).Take(20).Print()
    End Sub

End Module
