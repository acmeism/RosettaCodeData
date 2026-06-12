Const pi As Double = 4 * Atn(1)
Dim As Integer i, j
Dim As Double w, a = 0, b = 1, n = 10
Dim As Double cheby(n), coef(n)

For i = 0 To n-1
    coef(i) = Cos(Cos(pi/n*(i+1/2))*(b-a)/2+(b+a)/2)
Next i

For i = 0 To n-1
    w = 0
    For j = 0 To n-1
        w += coef(j) * Cos(pi/n*i*(j+1/2))
    Next j
    cheby(i) = w*2/n
    Print i; " : "; cheby(i)
Next i
Sleep
