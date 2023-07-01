Sub MainPalindromeDates()
Const FirstDate As String = "2020-02-02"
Const NumberOfDates As Integer = 15
Dim D As String, temp As String, Cpt As Integer
    temp = Format(DateAdd("d", 1, CDate(FirstDate)), "yyyy-mm-dd")
    Do
        D = Replace(temp, "-", "")
        If IsDatePalindrome(D) Then
            Debug.Print Left(D, 4) & "-" & Mid(D, 5, 2) & "-" & Right(D, 2)
            Cpt = Cpt + 1
        End If
        temp = Format(DateAdd("d", 1, CDate(temp)), "yyyy-mm-dd")
    Loop While Cpt < NumberOfDates
End Sub
Function IsDatePalindrome(strDate As String) As Boolean
    IsDatePalindrome = StrReverse(Left(strDate, 4)) = Right(strDate, 4)
End Function
