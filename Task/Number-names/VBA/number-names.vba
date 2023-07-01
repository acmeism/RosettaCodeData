Public twenties As Variant
Public decades As Variant
Public orders As Variant

Private Sub init()
    twenties = [{"zero","one","two","three","four","five","six","seven","eight","nine","ten", "eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen"}]
    decades = [{"twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety"}]
    orders = [{1E15,"quadrillion"; 1E12,"trillion"; 1E9,"billion"; 1E6,"million"; 1E3,"thousand"}]
End Sub

Private Function Twenty(N As Variant)
    Twenty = twenties(N Mod 20 + 1)
End Function

Private Function Decade(N As Variant)
    Decade = decades(N Mod 10 - 1)
End Function

Private Function Hundred(N As Variant)
    If N < 20 Then
        Hundred = Twenty(N)
        Exit Function
    Else
        If N Mod 10 = 0 Then
            Hundred = Decade((N \ 10) Mod 10)
            Exit Function
        End If
    End If
    Hundred = Decade(N \ 10) & "-" & Twenty(N Mod 10)
End Function

Private Function Thousand(N As Variant, withand As String)
    If N < 100 Then
        Thousand = withand & Hundred(N)
        Exit Function
    Else
        If N Mod 100 = 0 Then
            Thousand = withand & Twenty(WorksheetFunction.Floor_Precise(N / 100)) & " hundred"
            Exit Function
        End If
    End If
    Thousand = Twenty(N \ 100) & " hundred and " & Hundred(N Mod 100)
End Function

Private Function Triplet(N As Variant)
    Dim Order, High As Variant, Low As Variant
    Dim Name As String, res As String
    For i = 1 To UBound(orders)
        Order = orders(i, 1)
        Name = orders(i, 2)
        High = WorksheetFunction.Floor_Precise(N / Order)
        Low = N - High * Order 'N Mod Order
        If High <> 0 Then
            res = res & Thousand(High, "") & " " & Name
        End If
        N = Low
        If Low = 0 Then Exit For
        If Len(res) And High <> 0 Then
            res = res & ", "
        End If
    Next i
    If N <> 0 Or res = "" Then
        res = res & Thousand(WorksheetFunction.Floor_Precise(N), IIf(res = "", "", "and "))
        N = N - Int(N)
        If N > 0.000001 Then
            res = res & " point"
            For i = 1 To 10
                n_ = WorksheetFunction.Floor_Precise(N * 10.0000001)
                res = res & " " & twenties(n_ + 1)
                N = N * 10 - n_
                If Abs(N) < 0.000001 Then Exit For
            Next i
        End If
    End If
    Triplet = res
End Function

Private Function spell(N As Variant)
    Dim res As String
    If N < 0 Then
        res = "minus "
        N = -N
    End If
    res = res & Triplet(N)
    spell = res
End Function

Private Function smartp(N As Variant)
    Dim res As String
    If N = WorksheetFunction.Floor_Precise(N) Then
        smartp = CStr(N)
        Exit Function
    End If
    res = CStr(N)
    If InStr(1, res, ".") Then
        res = Left(res, InStr(1, res, "."))
    End If
    smartp = res
End Function

Sub Main()
    Dim si As Variant
    init
    Samples1 = [{99, 300, 310, 417, 1501, 12609, 200000000000100, 999999999999999, -123456787654321,102003000400005,1020030004,102003,102,1,0,-1,-99, -1501,1234,12.34}]
    Samples2 = [{10000001.2,1E-3,-2.7182818, 201021002001,-20102100200,2010210020,-201021002,20102100,-2010210, 201021,-20102,2010,-201,20,-2}]
    For i = 1 To UBound(Samples1)
        si = Samples1(i)
        Debug.Print Format(smartp(si), "@@@@@@@@@@@@@@@@"); " "; spell(si)
    Next i
    For i = 1 To UBound(Samples2)
        si = Samples2(i)
        Debug.Print Format(smartp(si), "@@@@@@@@@@@@@@@@"); " "; spell(si)
    Next i
End Sub
