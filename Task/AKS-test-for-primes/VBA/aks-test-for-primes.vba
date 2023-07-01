'-- Does not work for primes above 97, which is actually beyond the original task anyway.
'-- Translated from the C version, just about everything is (working) out-by-1, what fun.
'-- This updated VBA version utilizes the Decimal datatype to handle numbers requiring
'-- more than 32 bits.
Const MAX = 99
Dim c(MAX + 1) As Variant
Private Sub coef(n As Integer)
'-- out-by-1, ie coef(1)==^0, coef(2)==^1, coef(3)==^2 etc.
    c(n) = CDec(1) 'converts c(n) from Variant to Decimal, a 12 byte data type
    For i = n - 1 To 2 Step -1
        c(i) = c(i) + c(i - 1)
    Next i
End Sub
Private Function is_prime(fn As Variant) As Boolean
    fn = CDec(fn)
    Call coef(fn + 1)   '-- (I said it was out-by-1)
    For i = 2 To fn - 1 '-- (technically "to n" is more correct)
        If c(i) - fn * Int(c(i) / fn) <> 0 Then 'c(i) Mod fn <> 0 Then --Mod works upto 32 bit numbers
            is_prime = False: Exit Function
        End If
    Next i
    is_prime = True
End Function
Private Sub show(n As Integer)
'-- (As per coef, this is (working) out-by-1)
    Dim ci As Variant
    For i = n To 1 Step -1
        ci = c(i)
        If ci = 1 Then
            If (n - i) Mod 2 = 0 Then
                If i = 1 Then
                    If n = 1 Then
                        ci = "1"
                    Else
                        ci = "+1"
                    End If
                Else
                    ci = ""
                End If
            Else
                ci = "-1"
            End If
        Else
            If (n - i) Mod 2 = 0 Then
                ci = "+" & ci
            Else
                ci = "-" & ci
            End If
        End If
        If i = 1 Then '-- ie ^0
            Debug.Print ci
        Else
            If i = 2 Then '-- ie ^1
                Debug.Print ci & "x";
            Else
                Debug.Print ci & "x^" & i - 1;
            End If
        End If
    Next i
End Sub
Public Sub AKS_test_for_primes()
    Dim n As Integer
    For n = 1 To 10 '-- (0 to 9 really)
        coef n
        Debug.Print "(x-1)^" & n - 1 & " = ";
        show n
    Next n
    Debug.Print "primes (<="; MAX; "):"
    coef 2 '-- (needed to reset c, if we want to avoid saying 1 is prime...)
    For n = 2 To MAX
        If is_prime(n) Then
            Debug.Print n;
        End If
    Next n
End Sub
