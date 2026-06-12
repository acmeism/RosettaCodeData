Dim Shared As String*5 nums(2) = {"one", "two", "three"}
Dim Shared As String*7 shades(2) = {"solid", "striped", "open"}
Dim Shared As String*6 colours(2) = {"red", "green", "purple"}
Dim Shared As String*8 symbols(2) = {" diamond", "    oval", "squiggle"}

Sub showcard(card As Integer)
    Dim As Integer n, s, c, m
    n = card Mod 3
    card \= 3
    s = card Mod 3
    card \= 3
    c = card Mod 3
    card \= 3
    m = card Mod 3
    Print Trim(nums(n)); "  "; Trim(shades(s)); "  "; Trim(colours(c)); "  "; _
    Trim(symbols(m)); Iif(n = 0, "", "s")
End Sub

Sub showsets(hand() As Integer)
    Dim As Integer i, j, k
    Dim As Integer uh = Ubound(hand) + 1
    Color 14: Print "Cards dealt: "; uh
    Color 7: Print
    If uh <> 81 Then
        For i = 0 To uh - 1
            showcard(hand(i))
        Next
    End If
    Dim As Integer sets = 0
    For i = 0 To uh - 3
        For j = i + 1 To uh - 2
            For k = j + 1 To uh - 1
                If (hand(i) + hand(j) + hand(k)) Mod 3 = 0 Then sets += 1
            Next
        Next
    Next
    Print
    Color 11: Print "Sets present: "; sets
    Color 7: Print
    If uh <> 81 Then
        For i = 0 To uh - 3
            For j = i + 1 To uh - 2
                For k = j + 1 To uh - 1
                    If (hand(i) + hand(j) + hand(k)) Mod 3 = 0 Then
                        showcard(hand(i))
                        showcard(hand(j))
                        showcard(hand(k))
                        Print
                    End If
                Next
            Next
        Next
    End If
End Sub

Randomize Timer
Dim As Integer i, deal, j
Dim As Integer pack(80)
For i = 0 To 80
    pack(i) = i
Next

For deal = 4 To 81 Step 4
    For i = 80 To 1 Step -1
        j = Int(Rnd * (i + 1))
        Swap pack(i), pack(j)
    Next
    Dim As Integer hand(deal - 1)
    For i = 0 To deal - 1
        hand(i) = pack(i)
    Next
    showsets(hand())
Next

Sleep
