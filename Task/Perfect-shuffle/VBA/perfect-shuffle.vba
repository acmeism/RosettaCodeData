Option Explicit

Sub Main()
Dim T, Arr, X As Long, C As Long
   Arr = Array(8, 24, 52, 100, 1020, 1024, 10000)
   For X = LBound(Arr) To UBound(Arr)
      C = 0
      Call PerfectShuffle(T, CLng(Arr(X)), C)
      Debug.Print Right(String(19, " ") & "For " & Arr(X) & " cards => ", 19) & C & " shuffles needed."
      Erase T
   Next
End Sub

Private Sub PerfectShuffle(tb, NbCards As Long, Count As Long)
Dim arr1, arr2, StrInit As String, StrTest As String

   tb = CreateArray(1, NbCards)
   StrInit = Join(tb, " ")
   Do
      Count = Count + 1
      Call DivideArr(tb, arr1, arr2)
      tb = RemakeArray(arr1, arr2)
      StrTest = Join(tb, " ")
   Loop While StrTest <> StrInit
End Sub

Private Function CreateArray(First As Long, Length As Long) As String()
Dim i As Long, T() As String, C As Long
   If IsEven(Length) Then
      ReDim T(Length - 1)
      For i = First To First + Length - 1
         T(C) = i
         C = C + 1
      Next i
      CreateArray = T
   End If
End Function

Private Sub DivideArr(A, B, C)
Dim i As Long
   B = A
   ReDim Preserve B(UBound(A) \ 2)
   ReDim C(UBound(B))
   For i = LBound(C) To UBound(C)
      C(i) = A(i + UBound(B) + 1)
   Next
End Sub

Private Function RemakeArray(A1, A2) As String()
Dim i As Long, T() As String, C As Long
   ReDim T((UBound(A2) * 2) + 1)
   For i = LBound(T) To UBound(T) - 1 Step 2
      T(i) = A1(C)
      T(i + 1) = A2(C)
      C = C + 1
   Next
   RemakeArray = T
End Function

Private Function IsEven(Number As Long) As Boolean
    IsEven = (Number Mod 2 = 0)
End Function
