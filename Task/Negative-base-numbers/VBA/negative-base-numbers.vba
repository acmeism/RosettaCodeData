Const DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
Dim Str(63) As String
Private Function mod2(a As Long, b As Integer) As Long
    mod2 = a - (a \ b) * b
End Function
Private Function swap(a As String, b As String)
    Dim t As String
    t = a
    a = b
    b = t
End Function
Private Function EncodeNegativeBase(ByVal n As Long, base As Integer) As String
    Dim ptr, idx As Long
    Dim rem_ As Long
    Dim result As String
    If base > -1 Or base < -62 Then
        EncodeNegativeBase = result
    Else
        If n = 0 Then
            EncodeNegativeBase = "0"
        Else
            ptr = 0
            Do While n <> 0
                rem_ = mod2(n, base)
                n = n \ base
                If rem_ < 0 Then
                    n = n + 1
                    rem_ = rem_ - base
                End If
                result = result & Mid(DIGITS, rem_ + 1, 1)
            Loop
        End If
    End If
    EncodeNegativeBase = StrReverse(result)
End Function
Private Function DecodeNegativeBase(ns As String, base As Integer) As Long
    Dim total As Long, bb As Long
    Dim i As Integer, j As Integer
    If base < -62 Or base > -1 Then DecodeNegativeBase = 0
    If Mid(ns, 1, 1) = 0 Or (Mid(ns, 1, 1) = "0" And Mid(ns, 2, 1) = 0) Then DecodeNegativeBase = 0
    i = Len(ns)
    total = 0
    bb = 1
    Do While i >= 1
        j = InStr(1, DIGITS, Mid(ns, i, 1), vbTextCompare) - 1
        total = total + j * bb
        bb = bb * base
        i = i - 1
    Loop
    DecodeNegativeBase = total
End Function
Private Sub Driver(n As Long, b As Integer)
    Dim ns As String
    Dim p As Long
    ns = EncodeNegativeBase(n, b)
    Debug.Print CStr(n); " encoded in base "; b; " = "; ns
    p = DecodeNegativeBase(ns, b)
    Debug.Print ns; " decoded in base "; b; " = "; p
    Debug.Print
End Sub
Public Sub main()
    Driver 10, -2
    Driver 146, -3
    Driver 15, -10
    Driver 118492, -62
End Sub
