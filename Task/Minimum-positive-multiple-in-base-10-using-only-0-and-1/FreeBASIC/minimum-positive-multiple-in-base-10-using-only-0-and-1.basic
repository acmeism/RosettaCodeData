#define limit1 900
#define limit2 18703890759446315

Dim As Ulongint nplus, lenplus, prod
Dim As Boolean plusflag = false, flag
Dim As String pstr
Dim As Integer plus(6) = {297,576,594,891,909,999}

Print !"Minimum positive multiple in base 10 using only 0 and 1:\n"
Print "  N *       multiplier = B10"
For n As Ulongint = 1 To limit1
    If n = 106 Then
        plusflag = true
        nplus = 0
    End If
    lenplus = Ubound(plus)
    If plusflag = true Then
        nplus += 1
        If nplus < lenplus+1 Then
            n = plus(nplus)
        Else
            Exit For
        End If
    End If
    For m As Ulongint = 1 To limit2
        flag = true
        prod = n*m
        pstr = Str(prod)
        For p As Ulongint = 1 To Len(pstr)
            If Not(Mid(pstr,p,1) = "0" Or Mid(pstr,p,1) = "1") Then
                flag = false
                Exit For
            End If
        Next p
        If flag = true Then
            Print Using "### * ################ = &"; n; m; pstr
            Exit For
        End If
    Next m
    If n = 10 Then n = 94 : End If
Next n
Sleep
