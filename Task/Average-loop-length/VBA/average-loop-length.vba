Const MAX = 20
Const ITER = 1000000

Function expected(n As Long) As Double
    Dim sum As Double
    For i = 1 To n
        sum = sum + WorksheetFunction.Fact(n) / n ^ i / WorksheetFunction.Fact(n - i)
    Next i
    expected = sum
End Function

Function test(n As Long) As Double
    Dim count As Long
    Dim x As Long, bits As Long
    For i = 1 To ITER
        x = 1
        bits = 0
        Do While Not bits And x
            count = count + 1
            bits = bits Or x
            x = 2 ^ (Int(n * Rnd()))
        Loop
    Next i
    test = count / ITER
End Function

Public Sub main()
    Dim n As Long
    Debug.Print " n     avg.     exp.  (error%)"
    Debug.Print "==   ======   ======  ========"
    For n = 1 To MAX
        av = test(n)
        ex = expected(n)
        Debug.Print Format(n, "@@"); "  "; Format(av, "0.0000"); "   ";
        Debug.Print Format(ex, "0.0000"); "  ("; Format(Abs(1 - av / ex), "0.000%"); ")"
    Next n
End Sub
