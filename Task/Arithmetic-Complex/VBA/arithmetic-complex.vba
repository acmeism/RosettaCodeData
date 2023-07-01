Public Type Complex
    re As Double
    im As Double
End Type

Function CAdd(a As Complex, b As Complex) As Complex
    CAdd.re = a.re + b.re
    CAdd.im = a.im + b.im
End Function

Function CSub(a As Complex, b As Complex) As Complex
    CSub.re = a.re - b.re
    CSub.im = a.im - b.im
End Function

Function CMult(a As Complex, b As Complex) As Complex
    CMult.re = (a.re * b.re) - (a.im * b.im)
    CMult.im = (a.re * b.im) + (a.im * b.re)
End Function

Function CConj(a As Complex) As Complex
    CConj.re = a.re
    CConj.im = -a.im
End Function

Function CNeg(a As Complex) As Complex
    CNeg.re = -a.re
    CNeg.im = -a.im
End Function

Function CInv(a As Complex) As Complex
    CInv.re = a.re / (a.re * a.re + a.im * a.im)
    CInv.im = -a.im / (a.re * a.re + a.im * a.im)
End Function

Function CDiv(a As Complex, b As Complex) As Complex
    CDiv = CMult(a, CInv(b))
End Function

Function CAbs(a As Complex) As Double
    CAbs = Math.Sqr(a.re * a.re + a.im * a.im)
End Function

Function CSqr(a As Complex) As Complex
    CSqr.re = Math.Sqr((a.re + Math.Sqr(a.re * a.re + a.im * a.im)) / 2)
    CSqr.im = Math.Sgn(a.im) * Math.Sqr((-a.re + Math.Sqr(a.re * a.re + a.im * a.im)) / 2)
End Function

Function CPrint(a As Complex) As String
    If a.im > 0 Then
        Sep = "+"
    Else
        Sep = ""
    End If
    CPrint = a.re & Sep & a.im & "i"
End Function

Sub ShowComplexCalc()
Dim a As Complex
Dim b As Complex
Dim c As Complex

a.re = 1.5
a.im = 3
b.re = 1.5
b.im = 1.5

Debug.Print "a = " & CPrint(a)
Debug.Print "b = " & CPrint(b)

c = CAdd(a, b)
Debug.Print "a + b = " & CPrint(c)
c = CSub(a, b)
Debug.Print "a - b = " & CPrint(c)
c = CMult(a, b)
Debug.Print "a * b = " & CPrint(c)
c = CConj(a)
Debug.Print "Conj(a) = " & CPrint(c)
c = CNeg(a)
Debug.Print "-a = " & CPrint(c)
c = CInv(a)
Debug.Print "Inv(a) = " & CPrint(c)
c = CDiv(a, b)
Debug.Print "a / b = " & CPrint(c)
Debug.Print "Abs(a) = " & CAbs(a)
c = CSqr(a)
Debug.Print "Sqrt(a) = " & CPrint(c)
End Sub
