#include "isprime.bas"

Sub combinations(s As String, r As Integer, result() As String, Byref cnt As Integer, prefix As String = "", start As Integer = 1)
    If Len(prefix) = r Then
        cnt += 1
        Redim Preserve result(1 To cnt)
        result(cnt) = prefix
        Exit Sub
    End If
    For i As Integer = start To Len(s)
        combinations(s, r, result(), cnt, prefix + Mid(s, i, 1), i + 1)
    Next
End Sub

Function chkGroups(cadena As String) As Boolean
    Dim As String c1, c2
    Dim As Integer i, j
    For i = 1 To Len(cadena) - 1
        For j = i + 1 To Len(cadena)
            c1 = Mid(cadena, i, 1)
            c2 = Mid(cadena, j, 1)
            If isPrime(Abs(Asc(c1) - Asc(c2))) = 0 Then Return False
        Next
    Next
    Return True
End Function

' Main program
Dim As String s
Dim As Integer total = 0
Dim As String combos()
Dim As Integer j, i, cnt

Input "Enter a string: ", s

For j = 2 To Len(s)
    cnt = 0
    Erase combos
    combinations(s, j, combos(), cnt)
    For i = 1 To cnt
        If chkGroups(combos(i)) Then total += 1
    Next
Next

Print total

Sleep
