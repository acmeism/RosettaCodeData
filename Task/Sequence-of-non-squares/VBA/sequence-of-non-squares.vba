Sub Main()
Dim i&, c&, j#, s$
Const N& = 1000000
   s = "values for n in the range 1 to 22 : "
   For i = 1 To 22
      s = s & ns(i) & ", "
   Next
   For i = 1 To N
      j = Sqr(ns(i))
      If j = CInt(j) Then c = c + 1
   Next

   Debug.Print s
   Debug.Print c & " squares less than " & N
End Sub

Private Function ns(l As Long) As Long
   ns = l + Int(1 / 2 + Sqr(l))
End Function
