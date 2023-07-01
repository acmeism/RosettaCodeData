Option Explicit
Dim flag As Boolean ' true to print values
Sub main()
    Dim longest As Long, n As Long
    Dim i As Long, value As Long
    ' Task 1:
    flag = True
    i = 27
    Debug.Print "The hailstone sequence has length of "; i; " is "; hailstones(i)
    ' Task 2:
    flag = False
    longest = 0
    For i = 1 To 99999
        If longest < hailstones(i) Then
            longest = hailstones(i)
            value = i
        End If
    Next i
    Debug.Print value; " has the longest sequence of "; longest
End Sub 'main
Function hailstones(n As Long) As Long
    Dim m As Long, p As Long
    Dim m1 As Long, m2 As Long, m3 As Long, m4 As Long
    If flag Then Debug.Print "The sequence for"; n; "is: ";
    p = 1
    m = n
    If flag Then Debug.Print m;
    While m > 1
        p = p + 1
        If (m Mod 2) = 0 Then
            m = m / 2
        Else
            m = 3 * m + 1
        End If
        If p <= 4 Then If flag Then Debug.Print m;
        m4 = m3
        m3 = m2
        m2 = m1
        m1 = m
    Wend
    If flag Then
        If p <= 4 Then
            Debug.Print
        ElseIf p = 5 Then
            Debug.Print m1
        ElseIf p = 6 Then
            Debug.Print m2; m1
        ElseIf p = 7 Then
            Debug.Print m3; m2; m1
        ElseIf p = 8 Then
            Debug.Print m4; m3; m2; m1
        Else
            Debug.Print "..."; m4; m3; m2; m1
        End If
    End If
    hailstones = p
End Function 'hailstones
