' Bell numbers

Const MaxN As Integer = 14

Sub BellNumsMain()
  Dim A(MaxN - 1) As Long
  Dim N, J As Integer
  For I = 0 To MaxN - 1
    A(I) = 0
  Next I
  N = 0
  A(0) = 1
  Debug.Print "B(" & FormatLong(N, 2) & ") = " & FormatLong(A(0), 9)
  Do While N < MaxN
    A(N) = A(0)
    For J = N To 1 Step -1
      A(J - 1) = A(J - 1) + A(J)
    Next J
    N = N + 1
    Debug.Print "B(" & FormatLong(N, 2) & ") = " & FormatLong(A(0), 9)
  Loop
End Sub

Function FormatLong(ByVal Num As Long, L As Integer) As String
  Dim S As String
  S = Trim(Str(Num))
  If Len(S) > L Then
    FormatLong = String(L, "#")
  Else
    FormatLong = Right(String(L, " ") & S, L)
  End If
End Function
