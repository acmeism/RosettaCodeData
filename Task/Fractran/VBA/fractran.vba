Option Base 1
Public prime As Variant
Public nf As New Collection
Public df As New Collection
Const halt = 20
Private Sub init()
    prime = [{2,3,5,7,11,13,17,19,23,29,31}]
End Sub
Private Function factor(f As Long) As Variant
    Dim result(10) As Integer
    Dim i As Integer: i = 1
    Do While f > 1
        Do While f Mod prime(i) = 0
            f = f \ prime(i)
            result(i) = result(i) + 1
        Loop
        i = i + 1
    Loop
    factor = result
End Function
Private Function decrement(ByVal a As Variant, b As Variant) As Variant
    For i = LBound(a) To UBound(a)
        a(i) = a(i) - b(i)
    Next i
    decrement = a
End Function
Private Function increment(ByVal a As Variant, b As Variant) As Variant
    For i = LBound(a) To UBound(a)
        a(i) = a(i) + b(i)
    Next i
    increment = a
End Function
Private Function test(a As Variant, b As Variant)
    flag = True
    For i = LBound(a) To UBound(a)
        If a(i) < b(i) Then
            flag = False
            Exit For
        End If
    Next i
    test = flag
End Function
Private Function unfactor(x As Variant) As Long
    result = 1
    For i = LBound(x) To UBound(x)
        result = result * prime(i) ^ x(i)
    Next i
    unfactor = result
End Function
Private Sub compile(program As String)
    program = Replace(program, " ", "")
    programlist = Split(program, ",")
    For Each instruction In programlist
        parts = Split(instruction, "/")
        nf.Add factor(Val(parts(0)))
        df.Add factor(Val(parts(1)))
    Next instruction
End Sub
Private Function run(x As Long) As Variant
    n = factor(x)
    counter = 0
    Do While True
        For i = 1 To df.Count
            If test(n, df(i)) Then
                n = increment(decrement(n, df(i)), nf(i))
                Exit For
            End If
        Next i
        Debug.Print unfactor(n);
        counter = counter + 1
        If num = 31 Or counter >= halt Then Exit Do
    Loop
    Debug.Print
    run = n
End Function
Private Function steps(x As Variant) As Variant
    'expects x=factor(n)
    For i = 1 To df.Count
        If test(x, df(i)) Then
            x = increment(decrement(x, df(i)), nf(i))
            Exit For
        End If
    Next i
    steps = x
End Function
Private Function is_power_of_2(x As Variant) As Boolean
    flag = True
    For i = LBound(x) + 1 To UBound(x)
        If x(i) > 0 Then
            flag = False
            Exit For
        End If
    Next i
    is_power_of_2 = flag
End Function
Private Function filter_primes(x As Long, max As Integer) As Long
    n = factor(x)
    i = 0: iterations = 0
    Do While i < max
        If is_power_of_2(steps(n)) Then
            Debug.Print n(1);
            i = i + 1
        End If
        iterations = iterations + 1
    Loop
    Debug.Print
    filter_primes = iterations
End Function
Public Sub main()
    init
    compile ("17/91, 78/85, 19/51, 23/38, 29/33, 77/29, 95/23, 77/19, 1/17, 11/13, 13/11, 15/14,  15/2, 55/1")
    Debug.Print "First 20 results:"
    output = run(2)
    Debug.Print "First 30 primes:"
    Debug.Print "after"; filter_primes(2, 30); "iterations."
End Sub
