Module Module1
    Function Calc(f As Func(Of Integer, Integer()), n As Integer) As Double
        Dim temp = 0.0
        For ni = n To 1 Step -1
            Dim p = f(ni)
            temp = p(1) / (p(0) + temp)
        Next
        Return f(0)(0) + temp
    End Function

    Sub Main()
        Dim fList = {
            Function(n As Integer) New Integer() {If(n > 0, 2, 1), 1},
            Function(n As Integer) New Integer() {If(n > 0, n, 2), If(n > 1, n - 1, 1)},
            Function(n As Integer) New Integer() {If(n > 0, 6, 3), Math.Pow(2 * n - 1, 2)}
            }

        For Each f In fList
            Console.WriteLine(Calc(f, 200))
        Next
    End Sub

End Module
