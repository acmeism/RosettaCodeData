Option Explicit

Sub Main()
Debug.Print fFormat(13, 2, 1230.3333)
Debug.Print fFormat(2, 13, 1230.3333)
Debug.Print fFormat(10, 5, 0.3333)
Debug.Print fFormat(13, 2, 1230)
End Sub

Private Function fFormat(NbInt As Integer, NbDec As Integer, Nb As Double) As String
'NbInt : Lenght of integral part
'NbDec : Lenght of decimal part
'Nb : decimal on integer number
Dim u As String, v As String, i As Integer
   u = CStr(Nb)
   i = InStr(u, Application.DecimalSeparator)
   If i > 0 Then
      v = Mid(u, i + 1)
      u = Left(u, i - 1)
      fFormat = Right(String(NbInt, "0") & u, NbInt) & Application.DecimalSeparator & Left(v & String(NbDec, "0"), NbDec)
   Else
      fFormat = Right(String(NbInt, "0") & u, NbInt) & Application.DecimalSeparator & String(NbDec, "0")
   End If
End Function
