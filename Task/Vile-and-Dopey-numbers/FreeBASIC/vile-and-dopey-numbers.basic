Function isVile(n As Integer) As Boolean
    ' If n is odd, it's Vile
    If (n Mod 2) = 1 Then Return True
    ' Convert n to binary string
    Dim As String b = ""
    Dim As Integer t = n
    While t > 0
        b = Chr(48 + (t Mod 2)) + b
        t \= 2
    Wend
    ' Count trailing zeros
    Dim As Integer l1 = Len(b)
    Dim As Integer l2 = l1
    While l2 > 0 And Mid(b, l2, 1) = "0"
        l2 -= 1
    Wend
    ' If number of trimmed zeros is even, it's Vile
    Return ((l1 - l2) Mod 2) = 0
End Function

Dim As Integer viles(1 To 25), dopeys(1 To 25)
Dim As Integer vCnt = 0, dCnt = 0
Dim As Integer n = 1

While vCnt < 25 Or dCnt < 25
    If isVile(n) Then
        If vCnt < 25 Then
            vCnt += 1
            viles(vCnt) = n
        End If
    Else
        If dCnt < 25 Then
            dCnt += 1
            dopeys7(dCnt) = n
        End If
    End If
    n += 1
Wend

Print "First 25 Vile numbers:"
For i As Integer = 1 To 25
    Print Using "####"; viles(i);
    If (i Mod 5) = 0 Then Print
Next

Print !"\nFirst 25 Dopey numbers:"
For i As Integer = 1 To 25
    Print Using "####"; dopeys(i);
    If (i Mod 5) = 0 Then Print
Next

Print !"\nupto:  Vile  Dopey"
Dim As Integer limit = 2
Dim As Integer vc = 0, dc = 0
n = 1
Do
    If isVile(n) Then
        vc += 1
    Else
        dc += 1
    End If
    If n = limit Then
        Print Using "####:   ###    ###"; limit; vc; dc
        If limit = 1024 Then Exit Do
        limit *= 2
    End If
    n += 1
Loop

Sleep
