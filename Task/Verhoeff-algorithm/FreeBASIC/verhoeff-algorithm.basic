Dim Shared As Integer d(9, 9) = { _
{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, _
{1, 2, 3, 4, 0, 6, 7, 8, 9, 5}, _
{2, 3, 4, 0, 1, 7, 8, 9, 5, 6}, _
{3, 4, 0, 1, 2, 8, 9, 5, 6, 7}, _
{4, 0, 1, 2, 3, 9, 5, 6, 7, 8}, _
{5, 9, 8, 7, 6, 0, 4, 3, 2, 1}, _
{6, 5, 9, 8, 7, 1, 0, 4, 3, 2}, _
{7, 6, 5, 9, 8, 2, 1, 0, 4, 3}, _
{8, 7, 6, 5, 9, 3, 2, 1, 0, 4}, _
{9, 8, 7, 6, 5, 4, 3, 2, 1, 0} }

Dim Shared As Integer inv(9) = {0, 4, 3, 2, 1, 5, 6, 7, 8, 9}

Dim Shared As Integer p(7, 9) = { _
{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, _
{1, 5, 7, 6, 2, 8, 3, 0, 9, 4}, _
{5, 8, 0, 3, 7, 9, 6, 1, 4, 2}, _
{8, 9, 1, 6, 0, 4, 3, 5, 2, 7}, _
{9, 4, 5, 3, 1, 2, 6, 8, 7, 0}, _
{4, 2, 8, 6, 5, 7, 3, 9, 0, 1}, _
{2, 7, 9, 3, 8, 0, 6, 4, 1, 5}, _
{7, 0, 4, 6, 9, 1, 3, 2, 5, 8} }

Function Verhoeff(s As String, validate As Integer, table As Integer) As Integer
    Dim As Integer c, le, k, ni, pi
    If table Then
        Print
        Print Iif(validate, "Validation", "Check digit") & " calculations for '" & s & "':"
        Print !"\n i  ni  p[i,ni]  c\n------------------"
    End If
    If Not validate Then s = s & "0"
    c = 0
    le = Len(s) - 1
    For k = le To 0 Step -1
        ni = Asc(Mid(s, k + 1, 1)) - 48
        pi = p((le - k) Mod 8, ni)
        c = d(c, pi)
        If table Then Print Using "##  #      #     #"; le - k; ni; pi; c
    Next k
    If table And Not validate Then Print !"\ninv[" & c & "] = " & inv(c)
    Return Iif(Not validate, inv(c), c = 0)
End Function

Type miTipo
    s As String
    b As Boolean
End Type
Dim sts(2) As miTipo
sts(0).s = "236"          : sts(0).b = True
sts(1).s = "12345"        : sts(1).b = True
sts(2).s = "123456789012" : sts(2).b = False

Dim As Integer i, j, v , c
For i = 0 To 2
    c = Verhoeff(sts(i).s, False, sts(i).b)
    Print Using !"\nThe check digit for '&' is '&'"; sts(i).s; c
    Dim stc(1) As String = {Left(sts(i).s, Len(sts(i).s)-1) & Str(c), Left(sts(i).s, Len(sts(i).s)-1) & "9"}
    For j = 0 To Ubound(stc)
        v = Verhoeff(stc(j), True, sts(i).b)
        Print Using !"\nThe validation for '&' is "; stc(j);
        Print Iif (v, "correct", "incorrect"); "."
    Next j
    Print
Next i

Sleep
