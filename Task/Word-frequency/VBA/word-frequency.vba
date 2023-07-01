Option Explicit

Private Const PATHFILE As String = "C:\HOME\VBA\ROSETTA"

Sub Main()
Dim arr
Dim Dict As Object
Dim Book As String, temp As String
Dim T#
T = Timer
   Book = ExtractTxt(PATHFILE & "\les miserables.txt")
   temp = RemovePunctuation(Book)
   temp = UCase(temp)
   arr = Split(temp, " ")
   Set Dict = CreateObject("Scripting.Dictionary")
   FillDictionary Dict, arr
   Erase arr
   SortDictByFreq Dict, arr
   DisplayTheTopMostUsedWords arr, 10

Debug.Print "Words different in this book : " & Dict.Count
Debug.Print "-------------------------"
Debug.Print ""
Debug.Print "Optionally : "
Debug.Print "Frequency of the word MISERABLE : " & DisplayFrequencyOf("MISERABLE", Dict)
Debug.Print "Frequency of the word DISASTER : " & DisplayFrequencyOf("DISASTER", Dict)
Debug.Print "Frequency of the word ROSETTA_CODE : " & DisplayFrequencyOf("ROSETTA_CODE", Dict)
Debug.Print "-------------------------"
Debug.Print "Execution Time : " & Format(Timer - T, "0.000") & " sec."
End Sub

Private Function ExtractTxt(strFile As String) As String
'http://rosettacode.org/wiki/File_input/output#VBA
Dim i As Integer
   i = FreeFile
   Open strFile For Input As #i
       ExtractTxt = Input(LOF(1), #i)
   Close #i
End Function

Private Function RemovePunctuation(strBook As String) As String
Dim T, i As Integer, temp As String
Const PUNCT As String = """,;:!?."
   T = Split(StrConv(PUNCT, vbUnicode), Chr(0))
   temp = strBook
   For i = LBound(T) To UBound(T) - 1
      temp = Replace(temp, T(i), " ")
   Next
   temp = Replace(temp, "--", " ")
   temp = Replace(temp, "...", " ")
   temp = Replace(temp, vbCrLf, " ")
   RemovePunctuation = Replace(temp, "  ", " ")
End Function

Private Sub FillDictionary(d As Object, a As Variant)
Dim L As Long
   For L = LBound(a) To UBound(a)
      If a(L) <> "" Then _
         d(a(L)) = d(a(L)) + 1
   Next
End Sub

Private Sub SortDictByFreq(d As Object, myArr As Variant)
Dim K
Dim L As Long
   ReDim myArr(1 To d.Count, 1 To 2)
   For Each K In d.keys
      L = L + 1
      myArr(L, 1) = K
      myArr(L, 2) = CLng(d(K))
   Next
   SortArray myArr, LBound(myArr), UBound(myArr), 2
End Sub

Private Sub SortArray(a, Le As Long, Ri As Long, Col As Long)
Dim ref As Long, L As Long, r As Long, temp As Variant
   ref = a((Le + Ri) \ 2, Col)
   L = Le
   r = Ri
   Do
         Do While a(L, Col) < ref
            L = L + 1
         Loop
         Do While ref < a(r, Col)
            r = r - 1
         Loop
         If L <= r Then
            temp = a(L, 1)
            a(L, 1) = a(r, 1)
            a(r, 1) = temp
            temp = a(L, 2)
            a(L, 2) = a(r, 2)
            a(r, 2) = temp
            L = L + 1
            r = r - 1
         End If
   Loop While L <= r
   If L < Ri Then SortArray a, L, Ri, Col
   If Le < r Then SortArray a, Le, r, Col
End Sub

Private Sub DisplayTheTopMostUsedWords(arr As Variant, Nb As Long)
Dim L As Long, i As Integer
   i = 1
   Debug.Print "Rank Word    Frequency"
   Debug.Print "==== ======= ========="
   For L = UBound(arr) To UBound(arr) - Nb + 1 Step -1
      Debug.Print Left(CStr(i) & "    ", 5) & Left(arr(L, 1) & "       ", 8) & " " & Format(arr(L, 2), "0 000")
      i = i + 1
   Next
End Sub

Private Function DisplayFrequencyOf(Word As String, d As Object) As Long
   If d.Exists(Word) Then _
      DisplayFrequencyOf = d(Word)
End Function
