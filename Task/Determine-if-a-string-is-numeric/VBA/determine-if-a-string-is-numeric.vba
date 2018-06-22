Sub Main()
    Debug.Print Is_Numeric("")
    Debug.Print Is_Numeric("-5.32")
    Debug.Print Is_Numeric("-51,321 32")
    Debug.Print Is_Numeric("123.4")
    Debug.Print Is_Numeric("123,4")
    Debug.Print Is_Numeric("123;4")
    Debug.Print Is_Numeric("123.4x")
End Sub

Private Function Is_Numeric(s As String) As Boolean
Dim Separat As String, Other As String
    Separat = Application.DecimalSeparator
    Other = IIf(Separat = ",", ".", ",")
    Is_Numeric = IsNumeric(Replace(s, Other, Separat))
End Function
