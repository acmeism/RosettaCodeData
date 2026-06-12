#include "string.bi"

Dim As Integer limit = 1e8
Dim As Boolean kr(limit)
kr(1) = True
Dim As Integer n21 = 3, n31 = 4, p2 = 1, p3 = 1, count = 0, np10 = 1000
Print "First 100 Klarner-Rado sequence numbers:"
For i As Integer = 1 To limit
    If i = n21 Then
        If kr(p2) Then kr(i) = True
        p2  += 1
        n21 += 2
    End If
    If i = n31 Then
        If kr(p3) Then kr(i) = True
        p3  += 1
        n31 += 3
    End If
    If kr(i) Then
        count += 1
        If count <= 100 Then
            Print Using "####"; i;
            If(count Mod 20) = 0 Then Print
        Elseif count = np10 Then
            Print "The "; Format(count, "#,###,###"); "th Klarner-Rado number is "; Format(i, "#,###,###")
            np10 *= 10
        End If
    End If
Next i
Sleep
