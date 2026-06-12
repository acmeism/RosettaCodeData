#include "inc/crt/math.bi"

Const PI = 3.14159265358979323846

Type FuncDbl As Function(Byval x As Double) As Double

Function Tanh_Sinh(fp As FuncDbl, lower As Double, upper As Double, steps As Integer, acc As Double) As Double
    Dim As Double h = 0.1
    Dim As Double h0 = (upper - lower) / 2.0
    Dim As Double h1 = (lower + upper) / 2.0
    Dim As Double rr = 0.0
    For k As Integer = 1 To steps
        Dim As Double ro = rr
        Dim As Integer n = (1 Shl k) - 1
        Dim As Double ss = 0.0
        For i As Integer = -n To n
            Dim As Double t = i * h
            Dim As Double sh = Sinh(t)
            Dim As Double ch = Cosh(t)
            Dim As Double th = Tanh(sh * PI / 2.0)
            Dim As Double dx = (ch * PI / 2.0) / (Cosh(sh * PI / 2.0) ^ 2.0)
            Dim As Double xi = h1 + h0 * th
            Dim As Double wt = h * dx
            ss += fp(xi) * wt
        Next i
        rr = h0 * ss
        If Abs(rr - ro) < acc Then Exit For
    Next k
    Return rr
End Function

Function my_sin(x As Double) As Double
    Return Sin(x)
End Function

Function my_exp(x As Double) As Double
    Return Exp(x)
End Function

' Test program
Dim As Double res = Tanh_Sinh(@my_sin, 0.0, 1.0, 5, 1e-8)
Print Using "##.########"; res
res = Tanh_Sinh(@my_exp, -3.0, 3.0, 5, 1e-8)
Print Using "##.########"; res

Sleep
