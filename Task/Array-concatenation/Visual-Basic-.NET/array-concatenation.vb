    Dim iArray1() As Integer = {1, 2, 3}
    Dim iArray2() As Integer = {4, 5, 6}
    Dim iArray3() As Integer = Nothing

    iArray3 = iArray1.Concat(iArray2).ToArray
