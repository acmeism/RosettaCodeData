Option Explicit

Function JaroWinkler(text1 As String, text2 As String, Optional p As Double = 0.1) As Double
Dim dummyChar, match1, match2 As String
Dim i, f, t, j, m, l, s1, s2, limit As Integer

i = 1
Do
    dummyChar = Chr(i)
    i = i + 1
Loop Until InStr(1, text1 & text2, dummyChar, vbTextCompare) = 0

s1 = Len(text1)
s2 = Len(text2)
limit = WorksheetFunction.Max(0, Int(WorksheetFunction.Max(s1, s2) / 2) - 1)
match1 = String(s1, dummyChar)
match2 = String(s2, dummyChar)

For l = 1 To WorksheetFunction.Min(4, s1, s2)
    If Mid(text1, l, 1) <> Mid(text2, l, 1) Then Exit For
Next l
l = l - 1

For i = 1 To s1
    f = WorksheetFunction.Min(WorksheetFunction.Max(i - limit, 1), s2)
    t = WorksheetFunction.Min(WorksheetFunction.Max(i + limit, 1), s2)
    j = InStr(1, Mid(text2, f, t - f + 1), Mid(text1, i, 1), vbTextCompare)
    If j > 0 Then
        m = m + 1
        text2 = Mid(text2, 1, f + j - 2) & dummyChar & Mid(text2, f + j)
        match1 = Mid(match1, 1, i - 1) & Mid(text1, i, 1) & Mid(match1, i + 1)
        match2 = Mid(match2, 1, f + j - 2) & Mid(text1, i, 1) & Mid(match2, f + j)
    End If
Next i
match1 = Replace(match1, dummyChar, "", 1, -1, vbTextCompare)
match2 = Replace(match2, dummyChar, "", 1, -1, vbTextCompare)
t = 0
For i = 1 To m
    If Mid(match1, i, 1) <> Mid(match2, i, 1) Then t = t + 1
Next i

JaroWinkler = (m / s1 + m / s2 + (m - t / 2) / m) / 3
JaroWinkler = JaroWinkler + (1 - JaroWinkler) * l * WorksheetFunction.Min(0.25, p)
End Function
