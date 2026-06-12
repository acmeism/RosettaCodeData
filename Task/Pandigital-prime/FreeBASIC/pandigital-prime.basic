#include "isprime.bas"

Dim As Integer digits = 7654321
For z As Integer = 1 To 0 Step -1
    Print "The largest"; z; "..7 pandigital prime is ";
    Dim As Double start = Timer
    For n As Integer = digits To 0 Step -18
        Dim As String cadena = Str(n)
        Dim As Boolean flag = True
        For i As Integer = z To 7
            If Instr(cadena, Str(i)) = 0 Then
                flag = False
                Exit For
            End If
        Next i
        If flag And isPrime(n) Then
            Print Using "########.  ##.## ms"; n; (Timer - start) * 10000
            Exit For
        End If
    Next n
    digits = digits * 10 - 9
Next z
Sleep
