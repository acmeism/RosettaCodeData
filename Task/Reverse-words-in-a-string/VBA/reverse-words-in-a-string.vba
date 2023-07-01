Option Explicit

Sub Main()
Dim Lines(9) As String, i&
    'Input
    Lines(0) = "------------- Ice And Fire -------------"
    Lines(1) = ""
    Lines(2) = "fire, in end will world the say Some"
    Lines(3) = "ice. in say Some"
    Lines(4) = "desire of tasted I've what From"
    Lines(5) = "fire. favor who those with hold I"
    Lines(6) = ""
    Lines(7) = "... elided paragraph last ..."
    Lines(8) = ""
    Lines(9) = "Frost Robert -----------------------"
    'Output
    For i = 0 To 9
        Debug.Print ReverseLine(Lines(i), " ")
    Next
End Sub

Private Function ReverseLine(Line As String, Optional Separat As String) As String
Dim T, R, i&, j&, deb&, fin&
    If Len(Line) = 0 Then
        ReverseLine = vbNullString
    Else
        If Separat = "" Then Separat = " "
        T = Split(Line, Separat)
        ReDim R(UBound(T)): j = LBound(T)
        deb = UBound(T): fin = deb / 2
        For i = deb To fin Step -1
            R(j) = T(i)
            R(i) = T(j)
            j = j + 1
        Next i
        ReverseLine = Join(R, Separat)
    End If
End Function
