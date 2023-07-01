Option Explicit

Sub Main()
Dim a, r, i As Integer
Const SCHEM As String = "(X), (X), bo-b(Y)^Banana-fana fo-f(Y)^Fee-fi-mo-m(Y)^(X)!^"
   'init
   a = Array("GaRY", "Earl", "Billy", "Felix", "Mary", "Mike", "Frank")
   'compute
   r = TheGameName(a, SCHEM)
   'return
   For i = LBound(r) To UBound(r)
      Debug.Print r(i)
   Next i
End Sub

Private Function TheGameName(MyArr, S As String) As String()
Dim i As Integer, s1 As String, s2 As String, tp As String, t() As String
   ReDim t(UBound(MyArr))
   For i = LBound(MyArr) To UBound(MyArr)
      tp = Replace(S, "^", vbCrLf)
      s2 = LCase(Mid(MyArr(i), 2)): s1 = UCase(Left(MyArr(i), 1)) & s2
      Select Case UCase(Left(MyArr(i), 1))
         Case "A", "E", "I", "O", "U": tp = Replace(tp, "(Y)", LCase(MyArr(i)))
         Case "B", "F", "M"
            tp = Replace(tp, "(Y)", s2)
            tp = Replace(tp, LCase(MyArr(i)), s2)
         Case Else: tp = Replace(tp, "(Y)", s2)
      End Select
      t(i) = Replace(tp, "(X)", s1)
   Next
   TheGameName = t
End Function
