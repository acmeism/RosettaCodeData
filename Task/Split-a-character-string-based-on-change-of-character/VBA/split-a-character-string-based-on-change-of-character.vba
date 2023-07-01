Option Explicit

Sub Split_string_based_on_change_character()
Dim myArr() As String, T As String

Const STRINPUT As String = "gHHH5YY++///\"
Const SEP As String = ", "

    myArr = Split_Special(STRINPUT)
    T = Join(myArr, SEP)
    Debug.Print Left(T, Len(T) - Len(SEP))
End Sub

Function Split_Special(Ch As String) As String()
'return an array of Strings
Dim tb, i&, st As String, cpt As Long, R() As String

    tb = Split(StrConv(Ch, vbUnicode), Chr(0))
    st = tb(LBound(tb))
    ReDim R(cpt)
    R(cpt) = st
    For i = 1 To UBound(tb)
        If tb(i) = st Then
            R(cpt) = R(cpt) & st
        Else
            st = tb(i)
            cpt = cpt + 1
            ReDim Preserve R(cpt)
            R(cpt) = st
        End If
    Next
    Split_Special = R
End Function
