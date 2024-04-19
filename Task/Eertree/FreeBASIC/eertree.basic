Dim As String cadena = "eertree"
Dim As Integer n, m, p, cnt = 0
Dim As String strpal, strrev
Dim As String pal(1 To Len(cadena)^2)

For n = 1 To Len(cadena)
    For m = n To Len(cadena)
        strpal = Mid(cadena, n, m-n+1)
        strrev = ""
        For p = Len(strpal) To 1 Step -1
            strrev &= Mid(strpal, p, 1)
        Next p
        If strpal = strrev Then
            cnt += 1
            pal(cnt) = strpal
        End If
    Next m
Next n

For n = 1 To cnt-1
    For m = n+1 To cnt
        If pal(n) > pal(m) Then
            Swap pal(n), pal(m)
        End If
    Next m
Next n

For n = cnt To 2 Step -1
    If pal(n) = pal(n-1) Then
        For m = n To cnt-1
            pal(m) = pal(m+1)
        Next m
        cnt -= 1
    End If
Next n

For n = 1 To cnt
    Print pal(n)
Next n

Sleep
