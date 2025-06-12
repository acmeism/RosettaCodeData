#define ceil(x) (-((-x*2.0-0.5) Shr 1))

Dim As Double t0, f10, total, ratio
Dim As Integer first, f, digits, zeroes, v

t0 = Timer
f10 = Log(1) / Log(10)
total = 0
first = 0
For f = 2 To 50000
    f10 += Log(f) / Log(10)
    digits = Ceil(f10)
    zeroes = 0
    v = 5
    While v <= f
        zeroes += f \ v
        v *= 5
    Wend
    total += zeroes / digits
    ratio = total / f
    If ratio >= 0.07 Then
        first = 0
    Elseif first = 0 Then
        first = f
    End If
    If f = 100 Or f = 1000 Or f = 10000 Then
        Print Using "Mean proportion of trailing zeroes in factorials to ##### is #.######"; f; ratio
    End If
Next f

Print Using "The mean proportion dips permanently below 0.07 at &. (#.## seconds)"; first; (Timer - t0)

Sleep
