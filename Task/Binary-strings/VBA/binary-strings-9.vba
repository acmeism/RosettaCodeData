Sub ReplaceInString()
Dim A$, B As String, C$
    A = "Hello world"
    B = Chr(108)        ' "l"
    C = " "
    Debug.Print Replace(A, B, C)    'return : He  o wor d
End Sub
