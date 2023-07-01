' Levenshtein distance - 23/04/2020

Function Min(a,b)
    If a < b then Min = a : Else  Min = b
End Function 'Min

Function Levenshtein(s1, s2)
    Dim d(), i, j, n1, n2, d1, d2, d3
    n1 = Len(s1) + 1
    n2 = Len(s2) + 1
    ReDim d(n1, n2)
    If n1 = 1 Then
        Levenshtein = n2 - 1
        Exit Function
    End If
    If n2 = 1 Then
        Levenshtein = n1 - 1
        Exit Function
    End If
    For i = 1 To n1
        d(i, 1) = i - 1
    Next
    For j = 1 To n2
        d(1, j) = j - 1
    Next
    For i = 2 To n1
        For j = 2 To n2
            d1 = d(i - 1, j    ) + 1
            d2 = d(i,     j - 1) + 1
            d3 = d(i - 1, j - 1) + Abs(Mid(s1, i - 1, 1) <> Mid(s2, j - 1, 1))
            d(i, j) = Min(d1, Min(d2, d3))
        Next
    Next
    Levenshtein = d(n1, n2)
End Function 'Levenshtein

Sub PrintLevenshtein(c1, c2)
	WScript.StdOut.WriteLine c1&" "& c2&" "& Levenshtein(c1, c2)
End Sub 'PrintLevenshtein

PrintLevenshtein "kitten", "sitting"
PrintLevenshtein "rosettacode", "raisethysword"
PrintLevenshtein "saturday", "sunday"
PrintLevenshtein "sleep", "fleeting"
