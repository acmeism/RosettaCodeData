Option Explicit
Sub Main()
Dim s() As String, i As Long
        Debug.Print "list of 10 passwords : "
'do a list of 10 passwords with password's lenght = 21 and visually similar = False
    s = Gp(10, 21, False)
        'return
        Debug.Print "1- with password's lenght = 21 and visually similar = False :"
        For i = 1 To UBound(s): Debug.Print s(i): Next
'do a list of 10 passwords with pattern = "A/9-a/1-9/4-!/5" and visually similar = True
    s = Gp(10, "A/9-a/1-9/4-!/5", True)
        'return
        Debug.Print "2- with pattern = ""A/9-a/1-9/4-!/5"" and visually similar = True :"
        For i = 1 To UBound(s): Debug.Print s(i): Next
End Sub
Sub HelpMe()
Dim s As String
    s = "Help :" & vbCrLf
    s = s & "----------------------------------" & vbCrLf
    s = s & "The function (named : Gp) needs 3 required parameters :" & vbCrLf & vbCrLf
    s = s & "1- Nb_Passwords (Long) : the number of passwords to generate." & vbCrLf & vbCrLf
    s = s & "2- NbChar_Or_Pattern (Variant) : either a number or a pattern" & vbCrLf
    s = s & "      If number : NbChar_Or_Pattern specify the password length. All the digits are random ASCII characters" & vbCrLf
    s = s & "      If pattern : NbChar_Or_Pattern specify the password length and the layout of passwords." & vbCrLf
    s = s & "             The pattern is built like this :" & vbCrLf
    s = s & "                 ""A"" means Upper case, ""a"" means lower case, 9 means numerics and ! means others characters." & vbCrLf
    s = s & "                 ""-"" is the separator between these values." & vbCrLf
    s = s & "                 the number of characters is specified after the sign (required): ""/""" & vbCrLf
    s = s & "                 example of pattern available : ""A/3-a/2-9/1-!/1""" & vbCrLf & vbCrLf
    s = s & "3- Excl_Similar_Chars (Boolean) : True if you want the option of excluding visually similar characters."
    Debug.Print s
End Sub
Private Function Gp(Nb_Passwords As Long, NbChar_Or_Pattern As Variant, Excl_Similar_Chars As Boolean) As String()
'generate a list of passwords
Dim l As Long, s() As String
    ReDim s(1 To Nb_Passwords)
    If IsNumeric(NbChar_Or_Pattern) Then
        For l = 1 To Nb_Passwords
            s(l) = p(CLng(NbChar_Or_Pattern), Excl_Similar_Chars)
        Next l
    Else
        For l = 1 To Nb_Passwords
            s(l) = ttt(CStr(NbChar_Or_Pattern), Excl_Similar_Chars)
        Next l
    End If
    Gp = s
End Function
Public Function p(n As Long, e As Boolean) As String
'create 1 password without pattern (just with the password's lenght)
Dim t As String, i As Long, a As Boolean, b As Boolean, c As Boolean, d As Boolean
    Randomize Timer
    If n < 4 Then
        p = "Error. Numbers of characters is too small. Min : 4"
    ElseIf n >= 4 And n < 7 Then
        T = u(122, 97) & u(90, 65) & u(57, 48) & v
        For j = 5 To n
            i = Int((4 * Rnd) + 1)
            Select Case i
                Case 1: T = T & u(122, 97)
                Case 2: T = T & u(90, 65)
                Case 3: T = T & u(57, 48)
                Case 4: T = T & v
            End Select
        Next j
        'Debug.Print T
        p = y(T)
    Else
        Do
            i = Int((4 * Rnd) + 1)
            Select Case i
                Case 1: t = t & u(122, 97): a = True
                Case 2: t = t & u(90, 65): b = True
                Case 3: t = t & u(57, 48): c = True
                Case 4: t = t & v: d = True
            End Select
            If Len(t) >= 2 And e Then
                If x(t) Then t = Left(t, Len(t) - 1)
            End If
            If Len(t) = n Then
                If a And b And c And d Then
                    Exit Do
                Else
                    w t, a, b, c, d
                    p = p(n, e)
                End If
            ElseIf Len(t) > n Then
                w t, a, b, c, d
                p = p(n, e)
            End If
        Loop
        p = t
    End If
End Function
Public Function ttt(s As String, e As Boolean) As String
'create 1 password with pattern
Dim a, i As Long, j As Long, st As String, Nb As Long
    a = Split(s, "-")
    For i = 0 To UBound(a)
        Select Case Left(a(i), 1)
            Case "A"
                Nb = CLng(Split(a(i), "/")(1)): j = 0
                Do
                    j = j + 1
                    st = st & u(90, 65)
                    If Len(st) >= 2 And e Then
                        If x(st) Then st = Left(st, Len(st) - 1): j = j - 1
                    End If
                Loop While j < Nb
            Case "a"
                Nb = CLng(Split(a(i), "/")(1)): j = 0
                Do
                    j = j + 1
                    st = st & u(122, 97)
                    If Len(st) >= 2 And e Then
                        If x(st) Then st = Left(st, Len(st) - 1): j = j - 1
                    End If
                Loop While j < Nb
            Case "9"
                Nb = CLng(Split(a(i), "/")(1)): j = 0
                Do
                    j = j + 1
                    st = st & u(57, 48)
                    If Len(st) >= 2 And e Then
                        If x(st) Then st = Left(st, Len(st) - 1): j = j - 1
                    End If
                Loop While j < Nb
            Case "!"
                Nb = CLng(Split(a(i), "/")(1)): j = 0
                Do
                    j = j + 1
                    st = st & v
                    If Len(st) >= 2 And e Then
                        If x(st) Then st = Left(st, Len(st) - 1): j = j - 1
                    End If
                Loop While j < Nb
        End Select
    Next i
    ttt = y(st)
End Function
Private Function u(m As Long, l As Long) As String
'random 1 character in lower/upper case or numeric
    Randomize Timer
    u = Chr(Int(((m - l + 1) * Rnd) + l))
End Function
Private Function v() As String
'random 1 character "special"
    Randomize Timer
    v = Mid("!""#$%&'()*+,-./:;<=>?@[]^_{|}~", Int((30 * Rnd) + 1), 1)
End Function
Private Sub w(t As String, a As Boolean, b As Boolean, c As Boolean, d As Boolean)
    t = vbNullString: a = False: b = False: c = False: d = False
End Sub
Private Function x(s As String) As Boolean
'option of excluding visually similar characters
Dim t, i As Long
Const d As String = "Il I1 l1 lI 1l 1I 0O O0 5S S5 2Z 2? Z? Z2 ?2 ?Z DO OD"
    t = Split(d, " ")
    For i = 0 To UBound(t)
        If Right(s, 2) = t(i) Then
            x = True: Exit Function
        End If
    Next
End Function
Private Function y(s As String) As String
'shuffle the password's letters only if pattern
Dim i&, t, r As String, d() As Long
    t = Split(StrConv(s, vbUnicode), Chr(0))
    d = z(UBound(t))
    For i = 0 To UBound(t)
        r = r & t(d(i))
    Next i
    y = Left(r, Len(r) - 1)
End Function
Private Function z(l As Long) As Long()
'http://rosettacode.org/wiki/Best_shuffle#VBA
Dim i As Long, ou As Long, temp() As Long
Dim c As New Collection
    ReDim temp(l)
    If l = 1 Then
        temp(0) = 0
    ElseIf l = 2 Then
        temp(0) = 1: temp(1) = 0
    Else
        Randomize
        Do
            ou = Int(Rnd * l)
            On Error Resume Next
            c.Add CStr(ou), CStr(ou)
            If Err <> 0 Then
                On Error GoTo 0
            Else
                temp(ou) = i
                i = i + 1
            End If
        Loop While c.Count <> l
    End If
    z = temp
End Function
