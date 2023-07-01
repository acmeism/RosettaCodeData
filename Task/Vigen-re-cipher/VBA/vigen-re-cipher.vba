Option Explicit

Sub test()
Dim Encryp As String
   Encryp = Vigenere("Beware the Jabberwock, my son! The jaws that bite, the claws that catch!", "vigenerecipher", True)
   Debug.Print "Encrypt:= """ & Encryp & """"
   Debug.Print "Decrypt:= """ & Vigenere(Encryp, "vigenerecipher", False) & """"
End Sub

Private Function Vigenere(sWord As String, sKey As String, Enc As Boolean) As String
Dim bw() As Byte, bk() As Byte, i As Long, c As Long
Const sW As String = "ÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝ"
Const sWo As String = "AAAAACEEEEIIIINOOOOOUUUUY"
Const A As Long = 65
Const N As Long = 26

   c = Len(sKey)
   i = Len(sWord)
   sKey = Left(IIf(c < i, StrRept(sKey, (i / c) + 1), sKey), i)
   sKey = StrConv(sKey, vbUpperCase)         'Upper case
   sWord = StrConv(sWord, vbUpperCase)
   sKey = StrReplace(sKey, sW, sWo)          'Replace accented characters
   sWord = StrReplace(sWord, sW, sWo)
   sKey = RemoveChars(sKey)                  'Remove characters (numerics, spaces, comas, ...)
   sWord = RemoveChars(sWord)
   bk = CharToAscii(sKey)                     'To work with Bytes instead of String
   bw = CharToAscii(sWord)
   For i = LBound(bw) To UBound(bw)
      Vigenere = Vigenere & Chr((IIf(Enc, ((bw(i) - A) + (bk(i) - A)), ((bw(i) - A) - (bk(i) - A)) + N) Mod N) + A)
   Next i
End Function

Private Function StrRept(s As String, N As Long) As String
Dim j As Long, c As String
   For j = 1 To N
      c = c & s
   Next
   StrRept = c
End Function

Private Function StrReplace(s As String, What As String, By As String) As String
Dim t() As String, u() As String, i As Long
   t = SplitString(What)
   u = SplitString(By)
   StrReplace = s
   For i = LBound(t) To UBound(t)
      StrReplace = Replace(StrReplace, t(i), u(i))
   Next i
End Function

Private Function SplitString(s As String) As String()
   SplitString = Split(StrConv(s, vbUnicode), Chr(0))
End Function

Private Function RemoveChars(str As String) As String
Dim b() As Byte, i As Long
   b = CharToAscii(str)
   For i = LBound(b) To UBound(b)
      If b(i) >= 65 And b(i) <= 90 Then RemoveChars = RemoveChars & Chr(b(i))
   Next i
End Function

Private Function CharToAscii(s As String) As Byte()
   CharToAscii = StrConv(s, vbFromUnicode)
End Function
