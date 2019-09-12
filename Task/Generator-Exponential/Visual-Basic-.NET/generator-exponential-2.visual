    Function SquaresWithoutCubesLinq() As IEnumerable(Of Integer)
        Return Squares().Where(Function(s) s <> Cubes().First(Function(c) c >= s))
    End Function
