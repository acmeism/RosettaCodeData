Option Explicit

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Private Const HT As String = "H T"

Public Sub PenneysGame()
Dim S$, YourSeq$, ComputeSeq$, i&, Seq$, WhoWin$, flag As Boolean

    Do
        S = WhoWillBeFirst(Choice("Who will be first"))
        If S = "ABORT" Then Exit Do
        Debug.Print S; " start"
        YourSeq = Choice("Your sequence", 3)
        If YourSeq Like "*ABORT*" Then Exit Do
        Debug.Print "Your sequence : " & YourSeq
        ComputeSeq = vbNullString
        For i = 1 To 3
            ComputeSeq = ComputeSeq & Random
        Next i
        Debug.Print "Computer sequence : " & ComputeSeq
        Seq = vbNullString
        Do
            Seq = Seq & Random
            Debug.Print Seq
            Sleep 1000
        Loop While Not Winner(ComputeSeq, YourSeq, Seq, WhoWin)
        Debug.Print WhoWin; " win"
        If MsgBox(WhoWin & " win" & vbCrLf & "Play again?", vbYesNo) = vbNo Then flag = True
        Debug.Print ""
    Loop While Not flag
    Debug.Print "Game over"
End Sub

Private Function WhoWillBeFirst(YourChoice As String) As String
Dim S$
    S = Random
    Select Case YourChoice
        Case "ABORT": WhoWillBeFirst = YourChoice
        Case Else:
            WhoWillBeFirst = IIf(S = YourChoice, "You", "Computer")
    End Select
End Function

Private Function Choice(Title As String, Optional Seq As Integer) As String
Dim S$, i&, t$
    If Seq = 0 Then Seq = 1
    t = Title
    For i = 1 To Seq
        S = vbNullString
        Do
            S = InputBox("Choose between H or T : ", t)
            If StrPtr(S) = 0 Then S = "Abort"
            S = UCase(S)
        Loop While S <> "H" And S <> "T" And S <> "ABORT"
        Choice = Choice & S
        t = Title & " " & Choice
        If Choice Like "*ABORT*" Then Exit For
    Next i
End Function

Private Function Random() As String
Randomize Timer
    Random = Split(HT, " ")(CInt(Rnd))
End Function

Private Function Winner(Cs$, Ys$, S$, W$) As Boolean
    If Len(S) < 3 Then
        Winner = False
    Else
        If Right(S, 3) = Cs And Right(S, 3) = Ys Then
            Winner = True
            W = "Computer & you"
        ElseIf Right(S, 3) = Cs And Right(S, 3) <> Ys Then
            Winner = True
            W = "Computer"
        ElseIf Right(S, 3) = Ys And Right(S, 3) <> Cs Then
            Winner = True
            W = "You"
        End If
    End If
End Function
