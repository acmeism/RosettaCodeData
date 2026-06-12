Type Vector
    dims(31) As Single
End Type

Function bitCount(i As Integer) As Integer
    i = i - ((i Shr 1) And &h55555555)
    i = (i And &h33333333) + ((i Shr 2) And &h33333333)
    i = (i + (i Shr 4)) And &h0f0f0f0f
    i = i + (i Shr 8)
    i = i + (i Shr 16)
    Return i And &h0000003F
End Function

Function ReorderingSign(i As Integer, j As Integer) As Integer
    Dim As Integer k = i Shr 1
    Dim As Integer sum = 0
    While (k <> 0)
        sum += bitCount(k And j)
        k Shr= 1
    Wend
    Return Iif((sum And 1) = 0, 1, -1)
End Function

Function dot(lhs As Vector, rhs As Vector) As Vector
    Dim result As Vector
    For i As Integer = 0 To 31
        result.dims(i) = 0.5 * (lhs.dims(i) * rhs.dims(i) + rhs.dims(i) * lhs.dims(i))
    Next i
    Return result
End Function

Function addition(lhs As Vector, rhs As Vector) As Vector
    Dim result As Vector
    For i As Integer = 0 To 31
        result.dims(i) = lhs.dims(i) + rhs.dims(i)
    Next i
    Return result
End Function

Function multiply(lhs As Vector, rhs As Vector) As Vector
    Dim result As Vector
    Dim As Single s
    Dim As Integer i, j, k
    For i = 0 To 31
        If lhs.dims(i) <> 0 Then
            For j = 0 To 31
                If rhs.dims(j) <> 0 Then
                    s = ReorderingSign(i, j) * lhs.dims(i) * rhs.dims(j)
                    k = i Xor j
                    result.dims(k) += s
                End If
            Next j
        End If
    Next i
    Return result
End Function

Function multiplyScalar(lhs As Vector, rhs As Single) As Vector
    Dim result As Vector
    For i As Integer = 0 To 31
        result.dims(i) = lhs.dims(i) * rhs
    Next i
    Return result
End Function

Function e(n As Integer) As Vector
    If n > 4 Then Print "n must be less than 5": End
    Dim result As Vector
    result.dims(1 Shl n) = 1
    Return result
End Function

Function randomVector() As Vector
    Dim result As Vector
    For i As Integer = 0 To 4
        result = addition(result, multiplyScalar(e(i), Rnd))
    Next i
    Return result
End Function

Function randomMultiVector() As Vector
    Dim result As Vector
    For i As Integer = 0 To 31
        result.dims(i) = Rnd
    Next i
    Return result
End Function

Randomize Timer
Dim a As Vector = randomMultiVector()
Dim b As Vector = randomMultiVector()
Dim c As Vector = randomMultiVector()
Dim x As Vector = randomVector()

' (ab)c == a(bc)
Print (multiply(multiply(a, b), c).dims(0))
Print (multiply(a, multiply(b, c)).dims(0))
Print

' a(b+c) == ab + ac
Print (multiply(a, addition(b, c)).dims(0))
Print (addition(multiply(a, b), multiply(a, c)).dims(0))
Print

' (a+b)c == ac + bc
Print (multiply(addition(a, b), c).dims(0))
Print (addition(multiply(a, c), multiply(b, c)).dims(0))
Print

' x^2 is real
Print (multiply(x, x).dims(0))

Sleep
