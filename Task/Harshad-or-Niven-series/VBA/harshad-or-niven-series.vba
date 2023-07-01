Option Explicit

Sub Main()
Dim i As Long, out As String, Count As Integer
   Do
      i = i + 1
      If IsHarshad(i) Then out = out & i & ", ": Count = Count + 1
   Loop While Count < 20
   Debug.Print "First twenty Harshad numbers are : " & vbCrLf & out & "..."

   i = 1000
   Do
      i = i + 1
   Loop While Not IsHarshad(i)
   Debug.Print "The first harshad number after 1000 is : " & i
End Sub

Function IsHarshad(sNumber As Long) As Boolean
Dim Summ As Long, i As Long, temp
   temp = Split(StrConv(sNumber, vbUnicode), Chr(0))
   For i = LBound(temp) To UBound(temp) - 1
      Summ = Summ + temp(i)
   Next i
   IsHarshad = sNumber Mod Summ = 0
End Function
