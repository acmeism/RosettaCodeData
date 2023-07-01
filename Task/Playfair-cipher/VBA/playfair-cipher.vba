Option Explicit

Private Type Adress
   Row As Integer
   Column As Integer
End Type

Private myTable() As String

Sub Main()
Dim keyw As String, boolQ As Boolean, text As String, test As Long
Dim res As String
   keyw = InputBox("Enter your keyword : ", "KeyWord", "Playfair example")
   If keyw = "" Then GoTo ErrorHand
   Debug.Print "Enter your keyword : " & keyw
   boolQ = MsgBox("Ignore Q when buiding table  y/n : ", vbYesNo) = vbYes
   Debug.Print "Ignore Q when buiding table  y/n : " & IIf(boolQ, "Y", "N")
   Debug.Print ""
   Debug.Print "Table : "
   myTable = CreateTable(keyw, boolQ)
   On Error GoTo ErrorHand
   test = UBound(myTable)
   On Error GoTo 0
   text = InputBox("Enter your text", "Encode", "hide the gold in the TRRE stump")
   If text = "" Then GoTo ErrorHand
   Debug.Print ""
   Debug.Print "Text to encode : " & text
   Debug.Print "-------------------------------------------------"
   res = Encode(text)
   Debug.Print "Encoded text is : " & res
   res = Decode(res)
   Debug.Print "Decoded text is : " & res
   text = InputBox("Enter your text", "Encode", "hide the gold in the TREE stump")
   If text = "" Then GoTo ErrorHand
   Debug.Print ""
   Debug.Print "Text to encode : " & text
   Debug.Print "-------------------------------------------------"
   res = Encode(text)
   Debug.Print "Encoded text is : " & res
   res = Decode(res)
   Debug.Print "Decoded text is : " & res
   Exit Sub
ErrorHand:
   Debug.Print "error"
End Sub

Private Function CreateTable(strKeyword As String, Q As Boolean) As String()
Dim r As Integer, c As Integer, temp(1 To 5, 1 To 5) As String, t, cpt As Integer
Dim strT As String, coll As New Collection
Dim s As String

   strKeyword = UCase(Replace(strKeyword, " ", ""))
   If Q Then
      If InStr(strKeyword, "J") > 0 Then
         Debug.Print "Your keyword isn't available with your choice : Not Q (==> J) !"
         Exit Function
      End If
   Else
      If InStr(strKeyword, "Q") > 0 Then
         Debug.Print "Your keyword isn't available with your choice : Q (==> Not J) !"
         Exit Function
      End If
   End If
   strT = IIf(Not Q, "ABCDEFGHIKLMNOPQRSTUVWXYZ", "ABCDEFGHIJKLMNOPRSTUVWXYZ")
   t = Split(StrConv(strKeyword, vbUnicode), Chr(0))
   For c = LBound(t) To UBound(t) - 1
      strT = Replace(strT, t(c), "")
      On Error Resume Next
      coll.Add t(c), t(c)
      On Error GoTo 0
   Next
   strKeyword = vbNullString
   For c = 1 To coll.Count
      strKeyword = strKeyword & coll(c)
   Next
   t = Split(StrConv(strKeyword & strT, vbUnicode), Chr(0))
   c = 1: r = 1
   For cpt = LBound(t) To UBound(t) - 1
      temp(r, c) = t(cpt)
      s = s & " " & t(cpt)
      c = c + 1
      If c = 6 Then c = 1: r = r + 1: Debug.Print "   " & s: s = ""
   Next
   CreateTable = temp
End Function

Private Function Encode(s As String) As String
Dim i&, t() As String, cpt&
   s = UCase(Replace(s, " ", ""))
   'insert "X"
   For i = 1 To Len(s) - 1
      If Mid(s, i, 1) = Mid(s, i + 1, 1) Then s = Left(s, i) & "X" & Right(s, Len(s) - i)
   Next
   'Do the pairs
   For i = 1 To Len(s) Step 2
      ReDim Preserve t(cpt)
      t(cpt) = Mid(s, i, 2)
      cpt = cpt + 1
   Next i
   If Len(t(UBound(t))) = 1 Then t(UBound(t)) = t(UBound(t)) & "X"
   Debug.Print "[the pairs : " & Join(t, " ") & "]"
   'swap the pairs
   For i = LBound(t) To UBound(t)
      t(i) = SwapPairsEncoding(t(i))
   Next
   Encode = Join(t, " ")
End Function

Private Function SwapPairsEncoding(s As String) As String
Dim r As Integer, c As Integer, d1 As String, d2 As String, Flag As Boolean
Dim addD1 As Adress, addD2 As Adress, resD1 As Adress, resD2 As Adress
   d1 = Left(s, 1): d2 = Right(s, 1)
   For r = 1 To 5
      For c = 1 To 5
         If d1 = myTable(r, c) Then addD1.Row = r: addD1.Column = c
         If d2 = myTable(r, c) Then addD2.Row = r: addD2.Column = c
         If addD1.Row <> 0 And addD2.Row <> 0 Then Flag = True: Exit For
      Next
      If Flag Then Exit For
   Next
   Select Case True
      Case addD1.Row = addD2.Row And addD1.Column <> addD2.Column
         'same row, different columns
         resD1.Column = IIf(addD1.Column + 1 = 6, 1, addD1.Column + 1)
         resD2.Column = IIf(addD2.Column + 1 = 6, 1, addD2.Column + 1)
         SwapPairsEncoding = myTable(addD1.Row, resD1.Column) & myTable(addD2.Row, resD2.Column)
      Case addD1.Row <> addD2.Row And addD1.Column = addD2.Column
         'same columns, different rows
         resD1.Row = IIf(addD1.Row + 1 = 6, 1, addD1.Row + 1)
         resD2.Row = IIf(addD2.Row + 1 = 6, 1, addD2.Row + 1)
         SwapPairsEncoding = myTable(resD1.Row, addD1.Column) & myTable(resD2.Row, addD2.Column)
      Case addD1.Row <> addD2.Row And addD1.Column <> addD2.Column
         'different rows, different columns
         resD1.Row = addD1.Row
         resD2.Row = addD2.Row
         resD1.Column = addD2.Column
         resD2.Column = addD1.Column
         SwapPairsEncoding = myTable(resD1.Row, resD1.Column) & myTable(resD2.Row, resD2.Column)
   End Select
End Function

Private Function Decode(s As String) As String
Dim t, i&, j&, e&
   t = Split(s, " ")
   e = UBound(t) - 1
   'swap the pairs
   For i = LBound(t) To UBound(t)
      t(i) = SwapPairsDecoding(CStr(t(i)))
   Next
   'remove "X"
   For i = LBound(t) To e
      If Right(t(i), 1) = "X" And Left(t(i), 1) = Left(t(i + 1), 1) Then
         t(i) = Left(t(i), 1) & Left(t(i + 1), 1)
         For j = i + 1 To UBound(t) - 1
            t(j) = Right(t(j), 1) & Left(t(j + 1), 1)
         Next j
         If Right(t(j), 1) = "X" Then
            ReDim Preserve t(j - 1)
         Else
            t(j) = Right(t(j), 1) & "X"
         End If
      ElseIf Left(t(i + 1), 1) = "X" And Right(t(i), 1) = Right(t(i + 1), 1) Then
         For j = i + 1 To UBound(t) - 1
            t(j) = Right(t(j), 1) & Left(t(j + 1), 1)
         Next j
         If Right(t(j), 1) = "X" Then
            ReDim Preserve t(j - 1)
         Else
            t(j) = Right(t(j), 1) & "X"
         End If
      End If
   Next
   Decode = Join(t, " ")
End Function

Private Function SwapPairsDecoding(s As String) As String
Dim r As Integer, c As Integer, d1 As String, d2 As String, Flag As Boolean
Dim addD1 As Adress, addD2 As Adress, resD1 As Adress, resD2 As Adress
   d1 = Left(s, 1): d2 = Right(s, 1)
   For r = 1 To 5
      For c = 1 To 5
         If d1 = myTable(r, c) Then addD1.Row = r: addD1.Column = c
         If d2 = myTable(r, c) Then addD2.Row = r: addD2.Column = c
         If addD1.Row <> 0 And addD2.Row <> 0 Then Flag = True: Exit For
      Next
      If Flag Then Exit For
   Next
   Select Case True
      Case addD1.Row = addD2.Row And addD1.Column <> addD2.Column
         'same row, different columns
         resD1.Column = IIf(addD1.Column - 1 = 0, 5, addD1.Column - 1)
         resD2.Column = IIf(addD2.Column - 1 = 0, 5, addD2.Column - 1)
         SwapPairsDecoding = myTable(addD1.Row, resD1.Column) & myTable(addD2.Row, resD2.Column)
      Case addD1.Row <> addD2.Row And addD1.Column = addD2.Column
         'same columns, different rows
         resD1.Row = IIf(addD1.Row - 1 = 0, 5, addD1.Row - 1)
         resD2.Row = IIf(addD2.Row - 1 = 0, 5, addD2.Row - 1)
         SwapPairsDecoding = myTable(resD1.Row, addD1.Column) & myTable(resD2.Row, addD2.Column)
      Case addD1.Row <> addD2.Row And addD1.Column <> addD2.Column
         'different rows, different columns
         resD1.Row = addD1.Row
         resD2.Row = addD2.Row
         resD1.Column = addD2.Column
         resD2.Column = addD1.Column
         SwapPairsDecoding = myTable(resD1.Row, resD1.Column) & myTable(resD2.Row, resD2.Column)
   End Select
End Function
