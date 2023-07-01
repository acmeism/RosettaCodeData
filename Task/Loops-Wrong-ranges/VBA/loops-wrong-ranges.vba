Public Sub LoopsWrongRanges()
    Call Example(-2, 2, 1, "Normal")
    Call Example(-2, 2, 0, "Zero increment")
    Call Example(-2, 2, -1, "Increments away from stop value")
    Call Example(-2, 2, 10, "First increment is beyond stop value")
    Call Example(2, -2, 1, "Start more than stop: positive increment")
    Call Example(2, 2, 1, "Start equal stop: positive increment")
    Call Example(2, 2, -1, "Start equal stop: negative increment")
    Call Example(2, 2, 0, "Start equal stop: zero increment")
    Call Example(0, 0, 0, "Start equal stop equal zero: zero increment")
End Sub
Private Sub Example(start As Integer, stop_ As Integer, by As Integer, comment As String)
    Dim i As Integer
    Dim c As Integer
    Const limit = 10
    c = 0
    Debug.Print start; " "; stop_; " "; by; " | ";
    For i = start To stop_ Step by
        Debug.Print i & ",";
        c = c + 1
        If c > limit Then Exit For
    Next i
    Debug.Print
    Debug.Print comment & vbCrLf
End Sub
