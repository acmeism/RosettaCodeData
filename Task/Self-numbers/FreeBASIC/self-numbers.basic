Print "The first 50 self numbers are:"
Dim As Boolean flag
Dim As Ulong m, p, sum, number(), sum2
Dim As Ulong n = 0
Dim As Ulong num = 0
Dim As Ulong limit = 51
Dim As Ulong limit2 = 100000000
Dim As String strnum

Do
    n += 1
    For m = 1 To n
        flag = True
        sum = 0
        strnum = Str(m)
        For p = 1 To Len(strnum)
            sum += Val(Mid(strnum,p,1))
        Next p
        sum2 = m + sum
        If sum2 = n Then
            flag = False
            Exit For
        Else
            flag = True
        End If
    Next m
    If flag = True Then
        num += 1
        If num < limit Then Print ""; num; ". "; n
        If num >= limit2 Then
            Print "The "; limit2; "th self number is: "; n
            Exit Do
        End If
    End If
Loop
Sleep
