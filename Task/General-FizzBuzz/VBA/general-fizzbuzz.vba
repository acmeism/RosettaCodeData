Option Explicit

Private Type Choice
    Number As Integer
    Name As String
End Type

Private MaxNumber As Integer

Sub Main()
Dim U(1 To 3) As Choice, i As Integer, j As Integer, t$

    MaxNumber = Application.InputBox("Enter the max number : ", "Integer please", Type:=1)
    For i = 1 To 3
        U(i) = UserChoice
    Next
    For i = 1 To MaxNumber
        t = vbNullString
        For j = 1 To 3
            If i Mod U(j).Number = 0 Then t = t & U(j).Name
        Next
        Debug.Print IIf(t = vbNullString, i, t)
    Next i
End Sub

Private Function UserChoice() As Choice
Dim ok As Boolean

    Do While Not ok
        UserChoice.Number = Application.InputBox("Enter the factors to be calculated : ", "Integer please", Type:=1)
        UserChoice.Name = InputBox("Enter the corresponding word : ")
        If StrPtr(UserChoice.Name) <> 0 And UserChoice.Number < MaxNumber Then ok = True
    Loop
End Function
