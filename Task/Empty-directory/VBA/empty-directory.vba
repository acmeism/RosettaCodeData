Sub Main()
    Debug.Print IsEmptyDirectory("C:\Temp")
    Debug.Print IsEmptyDirectory("C:\Temp\")
End Sub

Private Function IsEmptyDirectory(D As String) As Boolean
Dim Sep As String
    Sep = Application.PathSeparator
    D = IIf(Right(D, 1) <> Sep, D & Sep, D)
    IsEmptyDirectory = (Dir(D & "*.*") = "")
End Function
