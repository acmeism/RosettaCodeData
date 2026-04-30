' Moebius function

Public Sub MainMoebius()
  Dim T, U As Integer
  For T = 0 To 9
     For U = 1 To 10
       Debug.Print FormatInteger(Moebius(10 * T + U), 2); "  ";
     Next U
     Debug.Print
  Next T
End Sub

Function FormatInteger(Num As Integer, L As Integer) As String
  Dim S As String
  S = LTrim(RTrim(Str(Num)))
  If Len(S) > L Then
    FormatInteger = String(L, "#")
  Else
    FormatInteger = Right(String(L, " ") & S, L)
  End If
End Function

Function Moebius(N As Integer) As Integer
  Dim M, F As Integer
  M = 1
  If N <> 1 Then
    F = 2
    Do
      If (N Mod (F * F)) = 0 Then
        M = 0
      Else
        If N Mod F = 0 Then
            M = -M
            N = N \ F
        End If
        F = F + 1
      End If
    Loop While (F <= N) And (M <> 0)
  End If
  Moebius = M
End Function
