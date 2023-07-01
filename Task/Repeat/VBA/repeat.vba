Private Sub Repeat(rid As String, n As Integer)
    For i = 1 To n
        Application.Run rid
    Next i
End Sub

Private Sub Hello()
    Debug.Print "Hello"
End Sub

Public Sub main()
    Repeat "Hello", 5
End Sub
