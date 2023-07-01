Sub Main()
Dim i As Integer, c As Integer, j As Integer, strReturn() As String
Dim s, n
   s = Split(SING_, "$")
   n = Split(NUMBERS_, " ")
   ReDim strReturn(UBound(s))
   For i = LBound(s) To UBound(s)
      strReturn(i) = Replace(BASE_, "(X)", n(i))
      For j = c To 0 Step -1
         strReturn(i) = strReturn(i) & s(j) & vbCrLf
      Next
      c = c + 1
   Next i
   strReturn(UBound(strReturn)) = Replace(strReturn(UBound(strReturn)), "and" & vbCrLf & "A", vbCrLf & "And a")
   Debug.Print Join(strReturn, vbCrLf)
End Sub
