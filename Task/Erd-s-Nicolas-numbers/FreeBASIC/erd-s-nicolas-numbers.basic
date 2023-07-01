Dim As Uinteger limite = 2e6
Dim As Uinteger DSum(limite+1), DCount(limite+1)
Dim As Integer i, j

For i = 0 To limite
    DSum(i) = 1
    DCount(i) = 1
Next i

For i = 2 To limite
    j = i + i
    While j <= limite
        If DSum(j) = j Then
            Print Using "######## equals the sum of its first ### divisors"; j; DCount(j)
        End If
        DSum(j) += i
        DCount(j) += 1
        j += i
    Wend
Next i
