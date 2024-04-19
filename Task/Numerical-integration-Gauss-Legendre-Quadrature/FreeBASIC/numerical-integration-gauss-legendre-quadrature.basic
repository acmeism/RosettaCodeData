#define PI 4 * Atn(1)
Const As Double LIM = 5

Dim Shared As Double lroots(LIM - 1)
Dim Shared As Double weight(LIM - 1)

Dim Shared As Double lcoef(LIM, LIM)
For i As Integer = 0 To LIM
    For j As Integer = 0 To LIM
        lcoef(i, j) = 0
    Next j
Next i

Sub legeCoef()
    lcoef(0, 0) = 1
    lcoef(1, 1) = 1
    For n As Integer = 2 To LIM
        lcoef(n, 0) = -(n - 1) * lcoef(n - 2, 0) / n
        For i As Integer = 1 To n
            lcoef(n, i) = ((2 * n - 1) * lcoef(n - 1, i - 1) - (n - 1) * lcoef(n - 2, i)) / n
        Next i
    Next n
End Sub

Function legeEval(n As Integer, x As Double) As Double
    Dim As Double s = lcoef(n, n)
    For i As Integer = n To 1 Step -1
        s = s * x + lcoef(n, i - 1)
    Next i
    Return s
End Function

Function legeDiff(n As Integer, x As Double) As Double
    Return n * (x * legeEval(n, x) - legeEval(n - 1, x)) / (x * x - 1)
End Function

Sub legeRoots()
    Dim As Double x = 0
    Dim As Double x1 = 0
    For i As Integer = 1 To LIM
        x = Cos(PI * (i - 0.25) / (LIM + 0.5))
        Do
            x1 = x
            x = x - legeEval(LIM, x) / legeDiff(LIM, x)
        Loop Until x = x1
        lroots(i - 1) = x
        x1 = legeDiff(LIM, x)
        weight(i - 1) = 2 / ((1 - x * x) * x1 * x1)
    Next i
End Sub

Function legeIntegrate(f As Function (As Double) As Double, a As Double, b As Double) As Double
    Dim As Double c1 = (b - a) / 2
    Dim As Double c2 = (b + a) / 2
    Dim As Double sum = 0
    For i As Integer = 0 To LIM - 1
        sum = sum + weight(i) * f(c1 * lroots(i) + c2)
    Next i
    Return c1 * sum
End Function

legeCoef()
legeRoots()

Print "Roots: ";
For i As Integer = 0 To LIM - 1
    Print Using " ##.######"; lroots(i);
Next i
Print

Print "Weight:";
For i As Integer = 0 To LIM - 1
    Print Using " ##.######"; weight(i);
Next i
Print

Function f(x As Double) As Double
    Return Exp(x)
End Function

Dim As Double actual = Exp(3) - Exp(-3)
Print Using !"Integrating exp(x) over [-3, 3]:\n\t########.######,\ncompared to actual\n\t########.######"; legeIntegrate(@f, -3, 3); actual

Sleep
