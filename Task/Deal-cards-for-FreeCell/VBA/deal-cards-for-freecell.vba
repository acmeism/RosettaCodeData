Option Explicit
Private stateMS As Variant

Private Function ms() As Integer
    Dim temp1 As Variant, temp2 As Variant, temp3 As Variant
    temp1 = CDec(214013 * stateMS + 2531011)
    temp2 = temp1 / 2 ^ 31
    temp3 = CDec(WorksheetFunction.Floor_Precise(temp2))
    stateMS = temp1 - (2 ^ 31) * temp3
    ms = stateMS \ 2 ^ 16
End Function

Public Sub main()
    Dim i As Integer, j As Integer, k As Integer, s As Integer, v As Integer, no As Integer
    Dim tmpArr(0 To 51) As Integer
    Dim suit As String, value As String, row As String
    Dim gameNumbers As Variant

    suit = "CDHS"
    value = "A23456789TJQK"

    gameNumbers = Array(1, 617)

    For i = 0 To UBound(gameNumbers)

        stateMS = CDec(gameNumbers(i))

        For j = 0 To 51
            tmpArr(j) = j
        Next j

        For j = 51 To 0 Step -1
            no = ms Mod (j + 1)
            Call changePosition(tmpArr(), j, no)
        Next j

        Debug.Print "Game " & gameNumbers(i) & ":"
        k = 0
        Do While k < 52
            For j = 0 To 7
                s = 1 + tmpArr(51 - k) Mod 4
                v = 1 + tmpArr(51 - k) \ 4
                row = row & Mid(value, v, 1) & Mid(suit, s, 1) & IIf(j < 7 and k < 51, " ", "")
                k = k + 1
                If k > 51 Then Exit For
            Next j
            Debug.Print row
            row = ""
        Loop
        Debug.Print

    Next i

End Sub

Private Sub changePosition(ByRef arr() As Integer, pos1 As Integer, pos2 As Integer)
    Dim tempPos As String
    tempPos = arr(pos1)
    arr(pos1) = arr(pos2)
    arr(pos2) = tempPos
End Sub
