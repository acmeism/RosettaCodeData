'#include "isprime.bas"

Function FactorSum(n As Uinteger) As Uinteger
    Dim As Uinteger result = 0
    Dim As Uinteger v = Abs(n)
    While v > 1 And v Mod 2 = 0
        result += 2
        v \= 2
    Wend
    For f As Uinteger = 3 To v Step 2
        While v > 1 And v Mod f = 0
            result += f
            v \= f
        Wend
    Next f
    Return result
End Function

Function DigitProduct(n As Uinteger, base_ As Uinteger) As Uinteger
    If n = 0 Then Return 0
    Dim As Uinteger result = 1
    Dim As Uinteger v = Abs(n)
    While v > 0
        result *= v Mod base_
        v \= base_
    Wend
    Return result
End Function

Function isRhonda(n As Uinteger, base_ As Uinteger) As Uinteger
    Return base_ * FactorSum(n) = DigitProduct(n, base_)
End Function

Function ToBaseString(n As Uinteger, base_ As Uinteger) As String
    If n = 0 Then Return "0"
    Dim As Uinteger under10 = Asc("0")
    Dim As Uinteger over9 = Asc("a") - 10
    Dim As String result = ""
    Dim As Uinteger v = Abs(n)
    While v > 0
        Dim As Uinteger d = v Mod base_
        result = Chr(d + Iif(d < 10, under10, over9)) + result
        v \= base_
    Wend
    Return result
End Function

Dim As Uinteger maxRhonda = 10, maxBase = 16
For base_ As Uinteger = 2 To maxBase
    If Not isPrime(base_) Then
        Print "The first "; maxRhonda; " Rhonda numbers in base "; base_; ":"
        Dim As Uinteger rCount = 0
        Dim As Uinteger rhonda(1 To maxRhonda)
        Dim As Uinteger n = 1
        While rCount < maxRhonda
            If isRhonda(n, base_) Then
                rCount += 1
                rhonda(rCount) = n
            End If
            n += 1
        Wend
        Print "    in base 10: ";
        For i As Uinteger = 1 To maxRhonda
            Print " "; rhonda(i);
        Next i
        Print
        If base_ <> 10 Then
            Print Using "    in base ##: "; base_;
            For i As Uinteger = 1 To maxRhonda
                Print " "; ToBaseString(rhonda(i), base_);
            Next i
            Print
        End If
    End If
Next base_

Sleep
