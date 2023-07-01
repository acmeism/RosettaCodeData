#include "isprime.bas"

Function GCD(p As Integer, q As Integer) As Integer
    Return Iif(q = 0, p, GCD(q, p Mod q))
End Function

Function SumDiv(Num As Uinteger) As Uinteger
    Dim As Uinteger Div = 2, Sum = 0, Quot
    Do
        Quot = Num / Div
        If Div > Quot Then Exit Do
        If Num Mod Div = 0 Then
            Sum += Div
            If Div <> Quot Then Sum += Quot
        End If
        Div += 1
    Loop
    Return Sum+1
End Function

Function Duff(N As Uinteger) As Boolean
    Return Iif(isPrime(N), False, GCD(SumDiv(N), N) = 1)
End Function

Dim As Integer C = 0, N = 4
Print "First 50 Duffinian numbers:"
Do
    If Duff(N) Then
        Print Using "####"; N;
        C += 1
        If C Mod 20 = 0 Then Print
    End If
    N += 1
Loop Until C >= 50

C = 0 : N = 4
Print !"\n\nFirst 50 Duffinian triplets:"
Do
    If Duff(N) And Duff(N+1) And Duff(N+2) Then
        Print Using !" [###### ###### ######]\t"; N; N+1; N+2;
        C += 1
        If C Mod 4 = 0 Then Print
    End If
    N += 1
Loop Until C >= 50

Sleep
