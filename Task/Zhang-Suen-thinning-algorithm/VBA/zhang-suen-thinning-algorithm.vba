Public n As Variant
Private Sub init()
    n = [{-1,0;-1,1;0,1;1,1;1,0;1,-1;0,-1;-1,-1;-1,0}]
End Sub

Private Function AB(text As Variant, y As Integer, x As Integer, step As Integer) As Variant
    Dim wtb As Integer
    Dim bn As Integer
    Dim prev As String: prev = "#"
    Dim next_ As String
    Dim p2468 As String
    For i = 1 To UBound(n)
        next_ = Mid(text(y + n(i, 1)), x + n(i, 2), 1)
        wtb = wtb - (prev = "." And next_ <= "#")
        bn = bn - (i > 1 And next_ <= "#")
        If (i And 1) = 0 Then p2468 = p2468 & prev
        prev = next_
    Next i
    If step = 2 Then '-- make it p6842
        p2468 = Mid(p2468, 3, 2) & Mid(p2468, 1, 2)
        'p2468 = p2468(3..4)&p2468(1..2)
    End If
    Dim ret(2) As Variant
    ret(0) = wtb
    ret(1) = bn
    ret(2) = p2468
    AB = ret
End Function

Private Sub Zhang_Suen(text As Variant)
    Dim wtb As Integer
    Dim bn As Integer
    Dim changed As Boolean, changes As Boolean
    Dim p2468 As String     '-- (p6842 for step 2)
    Dim x As Integer, y As Integer, step As Integer
    Do While True
        changed = False
        For step = 1 To 2
            changes = False
            For y = 1 To UBound(text) - 1
                For x = 2 To Len(text(y)) - 1
                    If Mid(text(y), x, 1) = "#" Then
                        ret = AB(text, y, x, step)
                        wtb = ret(0)
                        bn = ret(1)
                        p2468 = ret(2)
                        If wtb = 1 _
                            And bn >= 2 And bn <= 6 _
                            And InStr(1, Mid(p2468, 1, 3), ".") _
                            And InStr(1, Mid(p2468, 2, 3), ".") Then
                            changes = True
                            text(y) = Left(text(y), x - 1) & "!" & Right(text(y), Len(text(y)) - x)
                        End If
                    End If
                Next x
            Next y
            If changes Then
                For y = 1 To UBound(text) - 1
                    text(y) = Replace(text(y), "!", ".")
                Next y
                changed = True
            End If
        Next step
        If Not changed Then Exit Do
    Loop
    Debug.Print Join(text, vbCrLf)
End Sub

Public Sub main()
    init
    Dim Small_rc(9) As String
    Small_rc(0) = "................................"
    Small_rc(1) = ".#########.......########......."
    Small_rc(2) = ".###...####.....####..####......"
    Small_rc(3) = ".###....###.....###....###......"
    Small_rc(4) = ".###...####.....###............."
    Small_rc(5) = ".#########......###............."
    Small_rc(6) = ".###.####.......###....###......"
    Small_rc(7) = ".###..####..###.####..####.###.."
    Small_rc(8) = ".###...####.###..########..###.."
    Small_rc(9) = "................................"
    Zhang_Suen (Small_rc)
End Sub
