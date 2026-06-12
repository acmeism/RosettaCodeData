Function ArgMax(m() As Double, i As Integer) As Integer
    Dim As Integer n = Ubound(m, 1) + 1
    Dim As Double max = Abs(m(i, i))
    Dim As Integer maxx = i
    For x As Integer = i To n - 1
        If Abs(m(x, i)) > max Then
            max = Abs(m(x, i))
            maxx = x
        End If
    Next x
    Return maxx
End Function

Sub Gauss(m() As Double, col() As Double)
    Dim As Integer n = Ubound(m, 1) + 1
    Dim As Integer p = Ubound(m, 2) + 1
    Dim As Integer i, j, k, l
    For i = 0 To n - 1
        k = ArgMax(m(), i)
        If k <> i Then
            For j = 0 To p - 1
                Swap m(i, j), m(k, j)
            Next j
        End If
        Dim As Double t = 1 / m(i, i)
        For j = i + 1 To p - 1
            m(i, j) *= t
        Next j
        For j = i + 1 To n - 1
            t = m(j, i)
            For l = i + 1 To p - 1
                m(j, l) -= t * m(i, l)
            Next l
        Next j
    Next i
    For i = n - 1 To 0 Step -1
        For j = 0 To i - 1
            m(j, p - 1) -= m(j, i) * m(i, p - 1)
        Next j
    Next i
    For i = 0 To n - 1
        col(i) = m(i, p - 1)
    Next i
End Sub

Function Network(n As Integer, k0 As Integer, k1 As Integer, s As String) As Double
    Dim As Double m(n - 1, n)
    Dim As Integer i = 1
    Dim As String resistor = Mid(s, i, Instr(i, s, "|") - i)
    While Len(resistor) > 0
        Dim As Integer a = Val(Mid(resistor, 1, Instr(1, resistor, " ") - 1))
        Dim As Integer b = Val(Mid(resistor, Instr(1, resistor, " ") + 1, Instr(Instr(1, resistor, " ") + 1, resistor, " ") - Instr(1, resistor, " ") - 1))
        Dim As Integer ri = Val(Mid(resistor, Instr(Instr(1, resistor, " ") + 1, resistor, " ") + 1))
        Dim As Double r = 1.0 / ri
        m(a, a) += r
        m(b, b) += r
        If a > 0 Then m(a, b) -= r
        If b > 0 Then m(b, a) -= r
        i += Len(resistor) + 1
        resistor = Mid(s, i, Instr(i, s, "|") - i)
    Wend
    m(k0, k0) = 1
    m(k1, n) = 1
    Dim As Double col(n - 1)
    Gauss(m(), col())
    Return col(k1)
End Function

Dim As Double fa(3)
fa(0) = Network(7, 0, 1, "0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8")
fa(1) = Network(9, 0, 8, "0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1")
fa(2) = Network(16, 0, 15, "0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1")
fa(3) = Network(4, 0, 3, "0 1 150|0 2 50|1 3 300|2 3 250")

For i As Integer = 0 To Ubound(fa)
    Print Using "###.#####"; fa(i)
Next i

Sleep
