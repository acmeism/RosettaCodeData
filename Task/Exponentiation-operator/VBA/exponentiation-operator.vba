Public Function exp(ByVal base As Variant, ByVal exponent As Long) As Variant
    Dim result As Variant
    If TypeName(base) = "Integer" Or TypeName(base) = "Long" Then
        'integer exponentiation
        result = 1
        If exponent < 0 Then
            result = IIf(Abs(base) <> 1, CVErr(2019), IIf(exponent Mod 2 = -1, base, 1))
        End If
        Do While exponent > 0
            If exponent Mod 2 = 1 Then result = result * base
            base = base * base
            exponent = exponent \ 2
        Loop
    Else
        Debug.Assert IsNumeric(base)
        'float exponentiation
        If base = 0 Then
            If exponent < 0 Then result = CVErr(11)
        Else
            If exponent < 0 Then
                base = 1# / base
                exponent = -exponent
            End If
            result = 1
            Do While exponent > 0
                If exponent Mod 2 = 1 Then result = result * base
                base = base * base
                exponent = exponent \ 2
            Loop
        End If
    End If
    exp = result
End Function
Public Sub main()
    Debug.Print "Integer exponentiation"
    Debug.Print "10^7=", exp(10, 7)
    Debug.Print "10^4=", exp(10, 4)
    Debug.Print "(-3)^3=", exp(-3, 3)
    Debug.Print "(-1)^(-5)=", exp(-1, -5)
    Debug.Print "10^(-1)=", exp(10, -1)
    Debug.Print "0^2=", exp(0, 2)
    Debug.Print "Float exponentiation"
    Debug.Print "10.0^(-3)=", exp(10#, -3)
    Debug.Print "10.0^(-4)=", exp(10#, -4)
    Debug.Print "(-3.0)^(-5)=", exp(-3#, -5)
    Debug.Print "(-3.0)^(-4)=", exp(-3#, -4)
    Debug.Print "0.0^(-4)=", exp(0#, -4)
End Sub
