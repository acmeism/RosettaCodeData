Module Program
    Iterator Function IntegerPowers(exp As Integer) As IEnumerable(Of Integer)
        Dim i As Integer = 0
        Do
            Yield CInt(Math.Pow(i, exp))
            i += 1
        Loop
    End Function

    Function Squares() As IEnumerable(Of Integer)
        Return IntegerPowers(2)
    End Function

    Function Cubes() As IEnumerable(Of Integer)
        Return IntegerPowers(3)
    End Function

    Iterator Function SquaresWithoutCubes() As IEnumerable(Of Integer)
        Dim cubeSequence = Cubes().GetEnumerator()
        Dim nextGreaterOrEqualCube As Integer = 0
        For Each curSquare In Squares()
            Do While nextGreaterOrEqualCube < curSquare
                cubeSequence.MoveNext()
                nextGreaterOrEqualCube = cubeSequence.Current
            Loop
            If nextGreaterOrEqualCube <> curSquare Then Yield curSquare
        Next
    End Function

    Sub Main()
        For Each x In From i In SquaresWithoutCubes() Skip 20 Take 10
            Console.WriteLine(x)
        Next
    End Sub
End Module
