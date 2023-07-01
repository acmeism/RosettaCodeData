Function IsPrime(x As Long) As Boolean
    Dim i As Long
    If x Mod 2 = 0 Then
        Exit Function
    Else
        For i = 3 To Int(Sqr(x)) Step 2
            If x Mod i = 0 Then Exit Function
        Next i
    End If
    IsPrime = True
End Function

Function TwinPrimePairs(max As Long) As Long
    Dim p1 As Boolean, p2 As Boolean, count As Long, i As Long
    p2 = True
    For i = 5 To max Step 2
        p1 = p2
        p2 = IsPrime(i)
        If p1 And p2 Then count = count + 1
    Next i
    TwinPrimePairs = count
End Function

Sub Test(x As Long)
    Debug.Print "Twin prime pairs below" + Str(x) + ":" + Str(TwinPrimePairs(x))
End Sub

Sub Main()
    Test 10
    Test 100
    Test 1000
    Test 10000
    Test 100000
    Test 1000000
    Test 10000000
End Sub
