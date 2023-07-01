Sub ExtractFromString()
Dim A$, B As String
    A = "Hello world"
    B = Mid(A, 3, 8)
    Debug.Print B                   'return : llo worl
End Sub
