Option Explicit

Private Lines(1 To 3, 1 To 3) As String
Private Nb As Byte, player As Byte
Private GameWin As Boolean, GameOver As Boolean

Sub Main_TicTacToe()
Dim p As String

    InitLines
    printLines Nb
    Do
        p = WhoPlay
        Debug.Print p & " play"
        If p = "Human" Then
            Call HumanPlay
            GameWin = IsWinner("X")
        Else
            Call ComputerPlay
            GameWin = IsWinner("O")
        End If
        If Not GameWin Then GameOver = IsEnd
    Loop Until GameWin Or GameOver
    If Not GameOver Then
        Debug.Print p & " Win !"
    Else
        Debug.Print "Game Over!"
    End If
End Sub

Sub InitLines(Optional S As String)
Dim i As Byte, j As Byte
    Nb = 0: player = 0
    For i = LBound(Lines, 1) To UBound(Lines, 1)
        For j = LBound(Lines, 2) To UBound(Lines, 2)
            Lines(i, j) = "#"
        Next j
    Next i
End Sub

Sub printLines(Nb As Byte)
Dim i As Byte, j As Byte, strT As String
    Debug.Print "Loop " & Nb
    For i = LBound(Lines, 1) To UBound(Lines, 1)
        For j = LBound(Lines, 2) To UBound(Lines, 2)
            strT = strT & Lines(i, j)
        Next j
        Debug.Print strT
        strT = vbNullString
    Next i
End Sub

Function WhoPlay(Optional S As String) As String
    If player = 0 Then
        player = 1
        WhoPlay = "Human"
    Else
        player = 0
        WhoPlay = "Computer"
    End If
End Function

Sub HumanPlay(Optional S As String)
Dim L As Byte, C As Byte, GoodPlay As Boolean

    Do
        L = Application.InputBox("Choose the row", "Numeric only", Type:=1)
        If L > 0 And L < 4 Then
            C = Application.InputBox("Choose the column", "Numeric only", Type:=1)
            If C > 0 And C < 4 Then
                If Lines(L, C) = "#" And Not Lines(L, C) = "X" And Not Lines(L, C) = "O" Then
                    Lines(L, C) = "X"
                    Nb = Nb + 1
                    printLines Nb
                    GoodPlay = True
                End If
            End If
        End If
    Loop Until GoodPlay
End Sub

Sub ComputerPlay(Optional S As String)
Dim L As Byte, C As Byte, GoodPlay As Boolean

    Randomize Timer
    Do
        L = Int((Rnd * 3) + 1)
        C = Int((Rnd * 3) + 1)
        If Lines(L, C) = "#" And Not Lines(L, C) = "X" And Not Lines(L, C) = "O" Then
            Lines(L, C) = "O"
            Nb = Nb + 1
            printLines Nb
            GoodPlay = True
        End If
    Loop Until GoodPlay
End Sub

Function IsWinner(S As String) As Boolean
Dim i As Byte, j As Byte, Ch As String, strTL As String, strTC As String

    Ch = String(UBound(Lines, 1), S)
    'check lines & columns
    For i = LBound(Lines, 1) To UBound(Lines, 1)
        For j = LBound(Lines, 2) To UBound(Lines, 2)
            strTL = strTL & Lines(i, j)
            strTC = strTC & Lines(j, i)
        Next j
        If strTL = Ch Or strTC = Ch Then IsWinner = True: Exit For
        strTL = vbNullString: strTC = vbNullString
    Next i
    'check diagonales
    strTL = Lines(1, 1) & Lines(2, 2) & Lines(3, 3)
    strTC = Lines(1, 3) & Lines(2, 2) & Lines(3, 1)
    If strTL = Ch Or strTC = Ch Then IsWinner = True
End Function

Function IsEnd() As Boolean
Dim i As Byte, j As Byte

    For i = LBound(Lines, 1) To UBound(Lines, 1)
        For j = LBound(Lines, 2) To UBound(Lines, 2)
            If Lines(i, j) = "#" Then Exit Function
        Next j
    Next i
    IsEnd = True
End Function
