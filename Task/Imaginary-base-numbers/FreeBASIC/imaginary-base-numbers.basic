#define ceil(x) (-((-x*2.0-0.5) Shr 1))

Type Complex
    real As Double
    imag As Double
End Type

Type QuaterImaginary
    b2i As String
End Type

Dim Shared As Complex c1, c2

Function StrReverse(Byval txt As String) As String
    Dim result As String
    For i As Integer = Len(txt) To 1 Step -1
        result &= Mid(txt, i, 1)
    Next i
    Return result
End Function

Function ToChar(n As Integer) As String
    Return Chr(n + Asc("0"))
End Function

Function ComplexMul(lhs As Complex, rhs As Complex) As Complex
    Dim As Complex result
    result.real = rhs.real * lhs.real - rhs.imag * lhs.imag
    result.imag = rhs.real * lhs.imag + rhs.imag * lhs.real
    Return result
End Function

Function ComplexMulR(lhs As Complex, rhs As Double) As Complex
    Dim As Complex result
    result.real = lhs.real * rhs
    result.imag = lhs.imag * rhs
    Return result
End Function

Function ComplexInv(c As Complex) As Complex
    Dim As Double denom
    Dim As Complex result
    denom = c.real * c.real + c.imag * c.imag
    result.real = c.real / denom
    result.imag = -c.imag / denom
    Return result
End Function

Function ComplexDiv(lhs As Complex, rhs As Complex) As Complex
    Return ComplexMul(lhs, ComplexInv(rhs))
End Function

Function ComplexNeg(c As Complex) As Complex
    Dim As Complex result
    result.real = -c.real
    result.imag = -c.imag
    Return result
End Function

Function ComplexSum(lhs As Complex, rhs As Complex) As Complex
    Dim As Complex result
    result.real = lhs.real + rhs.real
    result.imag = lhs.imag + rhs.imag
    Return result
End Function

Function ToQuaterImaginary(c As Complex) As QuaterImaginary
    Dim As Integer re, im, fi, rem_, index
    Dim As Double f
    Dim As Complex t
    Dim As QuaterImaginary result
    Dim As String sb
    re = Int(c.real)
    im = Int(c.imag)
    fi = -1
    While re <> 0
        rem_ = (re Mod -4)
        re = re \ (-4)
        If rem_ < 0 Then
            rem_ = 4 + rem_
            re += 1
        End If
        sb &= ToChar(rem_) & "0"
    Wend
    If im <> 0 Then
        t = ComplexDiv(Type<Complex>(0.0, c.imag), Type<Complex>(0.0, 2.0))
        f = t.real
        im = Ceil(f)
        f = -4.0 * (f - Cdbl(im))
        index = 1
        While im <> 0
            rem_ = im Mod -4
            im \= -4
            If rem_ < 0 Then
                rem_ = 4 + rem_
                im += 1
            End If
            If index < Len(sb) Then
                Mid(sb, index + 1, 1) = ToChar(rem_)
            Else
                sb &= "0" & ToChar(rem_)
            End If
            index += 2
        Wend
        fi = Int(f)
    End If
    sb = StrReverse(sb)
    If fi <> -1 Then sb &= "." & ToChar(fi)
    sb = Ltrim(sb, "0")
    If Left(sb, 1) = "." Then sb = "0" & sb
    result.b2i = sb
    Return result
End Function

Function ToComplex(qi As QuaterImaginary) As Complex
    Dim As Integer j, pointPos, posLen, b2iLen
    Dim As Double k
    Dim As Complex sum, prod
    pointPos = Instr(qi.b2i, ".")
    posLen = Iif(pointPos = 0, Len(qi.b2i), pointPos - 1)
    sum.real = 0.0
    sum.imag = 0.0
    prod.real = 1.0
    prod.imag = 0.0
    For j = 0 To posLen - 1
        k = Val(Mid(qi.b2i, posLen - j, 1))
        If k > 0.0 Then sum = ComplexSum(sum, ComplexMulR(prod, k))
        prod = ComplexMul(prod, Type<Complex>(0.0, 2.0))
    Next
    If pointPos <> 0 Then
        prod = ComplexInv(Type<Complex>(0.0, 2.0))
        b2iLen = Len(qi.b2i)
        For j = posLen + 1 To b2iLen - 1
            k = Val(Mid(qi.b2i, j + 1, 1))
            If k > 0.0 Then sum = ComplexSum(sum, ComplexMulR(prod, k))
            prod = ComplexMul(prod, ComplexInv(Type<Complex>(0.0, 2.0)))
        Next
    End If
    Return sum
End Function

Dim As QuaterImaginary qi
Dim As Integer i
For i = 1 To 16
    c1.real = Cdbl(i)
    c1.imag = 0.0
    qi = ToQuaterImaginary(c1)
    c2 = ToComplex(qi)
    Print c1.real; "i -> "; qi.b2i; " -> "; c2.real; "i";
    c1 = ComplexNeg(c1)
    qi = ToQuaterImaginary(c1)
    c2 = ToComplex(qi)
    Print c1.real; "i -> "; qi.b2i; " -> "; c2.real; "i"
Next
Print
For i = 1 To 16
    c1.real = 0.0
    c1.imag = Cdbl(i)
    qi = ToQuaterImaginary(c1)
    c2 = ToComplex(qi)
    Print c1.imag; "i -> "; qi.b2i; " -> "; c2.imag; "i";
    c1 = ComplexNeg(c1)
    qi = ToQuaterImaginary(c1)
    c2 = ToComplex(qi)
    Print c1.imag; "i -> "; qi.b2i; " -> "; c2.imag; "i"
Next

Sleep
