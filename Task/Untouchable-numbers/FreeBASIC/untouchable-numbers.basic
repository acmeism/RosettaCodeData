Const max_untouchable = 1e6

Dim Shared untouchable(1 To max_untouchable) As Uinteger
For i As Uinteger = 1 To Ubound(untouchable)
    untouchable(i) = True
Next i

Sub show_untouchable_statistics()
    Dim As Uinteger i, cnt = 0
    For i = 1 To Ubound(untouchable)
        If untouchable(i) Then cnt += 1
        If i = 10 Orelse i = 100 Orelse i = 1000 Orelse i = 10000 Orelse i = 1e5 Then
            Print Using "###,### untouchable numbers were found  <= #,###,###"; cnt;  i
        End If
    Next i
End Sub

Sub print_untouchables(n As Uinteger)
    Print Using "List of untouchable numbers <= #,###:"; n
    Dim As Uinteger i, cnt = 0
    For i = 1 To n
        If untouchable(i) Then
            Print Using "##,###"; i;
            cnt += 1
            Print Iif(cnt Mod 16 = 0, !"\n", " ");
        End If
    Next i
    Print: Print
    Print Using "###,### untouchable numbers were found  <= #,###,###"; cnt; n
End Sub

Dim As Uinteger i, j
untouchable(1) = False
untouchable(3) = False
For i = 7 To Ubound(untouchable) Step 2
    untouchable(i) = False
Next i

Dim Shared spd(1 To max_untouchable * 64) As Uinteger
Dim As Uinteger ub = Ubound(spd)
For i = 1 To ub
    spd(i) = 1
Next i
For i = 2 To ub
    For j = i + i To ub Step i
        spd(j) += i
    Next j
Next i
For i = 1 To ub
    If spd(i) <= Ubound(untouchable) Then untouchable(spd(i)) = False
Next i

' Show the untouchable numbers up to 2000
print_untouchables(2000)
' Show the counts of untouchable numbers
show_untouchable_statistics()

Sleep
