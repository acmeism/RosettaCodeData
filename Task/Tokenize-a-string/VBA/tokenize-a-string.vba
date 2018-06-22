Sub Main()
Dim temp() As String
   temp = Tokenize("Hello,How,Are,You,Today", ",")
   Display temp, Space(5)
End Sub

Private Function Tokenize(strS As String, sep As String) As String()
   Tokenize = Split(strS, sep)
End Function

Private Sub Display(arr() As String, sep As String)
   Debug.Print Join(arr, sep)
End Sub
