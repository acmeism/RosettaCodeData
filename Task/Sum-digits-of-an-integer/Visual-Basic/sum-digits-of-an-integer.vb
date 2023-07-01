Function sumDigits(num As Variant, base As Long) As Long
    'can handle up to base 36
    Dim outp As Long
    Dim validNums As String, tmp As Variant, x As Long, lennum As Long
    'ensure num contains only valid characters
    validNums = Left$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", base)
    lennum = Len(num)
    For L0 = lennum To 1 Step -1
        x = InStr(validNums, Mid$(num, L0, 1)) - 1
        If -1 = x Then Exit Function
        tmp = tmp + (x * (base ^ (lennum - L0)))
    Next
    While tmp
        outp = outp + (tmp Mod base)
        tmp = tmp \ base
    Wend
    sumDigits = outp
End Function

Sub tester()
    Debug.Print sumDigits(1, 10)
    Debug.Print sumDigits(1234, 10)
    Debug.Print sumDigits(&HFE, 16)
    Debug.Print sumDigits(&HF0E, 16)
    Debug.Print sumDigits("2", 2)
End Sub
