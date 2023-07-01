Public Declare Function GetTickCount Lib "kernel32.dll" () As Long
'palindromes both in base3 and base2
'using Decimal data type to find number 6 and 7, although slowly
Private Function DecimalToBinary(DecimalNum As Long) As String
    Dim tmp As String
    Dim n As Long

    n = DecimalNum

    tmp = Trim(CStr(n Mod 2))
    n = n \ 2

    Do While n <> 0
    tmp = Trim(CStr(n Mod 2)) & tmp
    n = n \ 2
    Loop

    DecimalToBinary = tmp
End Function
Function Dec2Bin(ByVal DecimalIn As Variant, _
              Optional NumberOfBits As Variant) As String
    Dec2Bin = ""
    DecimalIn = Int(CDec(DecimalIn))
    Do While DecimalIn <> 0
        Dec2Bin = Format$(DecimalIn - 2 * Int(DecimalIn / 2)) & Dec2Bin
        DecimalIn = Int(DecimalIn / 2)
    Loop
    If Not IsMissing(NumberOfBits) Then
       If Len(Dec2Bin) > NumberOfBits Then
          Dec2Bin = "Error - Number exceeds specified bit size"
       Else
          Dec2Bin = Right$(String$(NumberOfBits, _
                    "0") & Dec2Bin, NumberOfBits)
       End If
    End If
End Function
Public Sub base()
    'count integer n from 0 upwards
    'display representation in base 3

    Time1 = GetTickCount
    Dim n As Long
    Dim three(19) As Integer
    Dim pow3(19) As Variant
    Dim full3 As Variant
    Dim trail As Variant
    Dim check As Long
    Dim len3 As Integer
    Dim carry As Boolean
    Dim i As Integer, j As Integer
    Dim s As String
    Dim t As String
    pow3(0) = CDec(1)
    For i = 1 To 19
        pow3(i) = 3 * pow3(i - 1)
    Next i
    Debug.Print String$(5, " "); "iter"; String$(7, " "); "decimal"; String$(18, " "); "binary";
    Debug.Print String$(30, " "); "ternary"
    n = 0: full3 = 0: t = "0": s = "0"
    Debug.Print String$(8 - Len(CStr(n)), " "); n; String$(12 - Len(CStr(full3)), " ");
    Debug.Print full3; String$((41 - Len(t)) / 2, " "); t; String$((41 - Len(t)) / 2, " ");
    Debug.Print String$((31 - Len(s)) / 2, " "); s
    n = 0: full3 = 1: t = "1": s = "1"
    Debug.Print String$(8 - Len(CStr(n)), " "); n; String$(12 - Len(CStr(full3)), " ");
    Debug.Print full3; String$((41 - Len(t)) / 2, " "); t; String$((41 - Len(t)) / 2, " ");
    Debug.Print String$((31 - Len(s)) / 2, " "); s
    number = 0
    n = 1
    len3 = 0
    full3 = 3
    Do 'For n = 1 To 200000 '20000000 takes 1000 seconds and number 7 not found yet
        three(0) = three(0) + 1
        carry = False
        If three(0) = 3 Then
            three(0) = 0
            carry = True
            j = 1
            Do While carry
                three(j) = three(j) + 1
                If three(j) = 3 Then
                    three(j) = 0
                    j = j + 1
                Else
                    carry = False
                End If
            Loop
            If len3 < j Then
                trail = full3 - (n - 1) * pow3(len3 + 2) - pow3(len3 + 1)
                len3 = j
                full3 = n * pow3(len3 + 2) + pow3(len3 + 1) + 3 * trail
                For i = 0 To j - 1
                    full3 = full3 - 2 * pow3(len3 - i)
                Next i
                full3 = full3 + 1 'as j=len3 now and 1=pow3(len3 - j)
            Else
                full3 = full3 + pow3(len3 + 2)
                For i = 0 To j - 1
                    full3 = full3 - 2 * pow3(len3 - i)
                Next i
                full3 = full3 + pow3(len3 - j)
            End If
        Else
            full3 = full3 + pow3(len3 + 2) + pow3(len3)
        End If
        s = ""
        For i = 0 To len3
            s = s & CStr(three(i))
        Next i
        'do we have a hit?
        t = Dec2Bin(full3) 'CStr(DecimalToBinary(full3))
        If t = StrReverse(t) Then
            'we have a hit
            number = number + 1
            s = StrReverse(s) & "1" & s
            If n < 200000 Then
                Debug.Print String$(8 - Len(CStr(n)), " "); n; String$(12 - Len(CStr(full3)), " ");
                Debug.Print full3; String$((41 - Len(t)) / 2, " "); t; String$((41 - Len(t)) / 2, " ");
                Debug.Print String$((31 - Len(s)) / 2, " "); s
                If number = 4 Then
                    Debug.Print "Completed in"; (GetTickCount - Time1) / 1000; "seconds"
                    Time2 = GetTickCount
                    Application.ScreenUpdating = False
                End If
            Else
                Debug.Print n, full3, Len(t), t, Len(s), s
                Debug.Print "Completed in"; (Time2 - Time1) / 1000; "seconds";
                Time3 = GetTickCount
            End If
        End If
        n = n + 1
    Loop Until number = 5 'Next n
    Debug.Print "Completed in"; (Time3 - Time1) / 1000; "seconds"
    Application.ScreenUpdating = True
End Sub
