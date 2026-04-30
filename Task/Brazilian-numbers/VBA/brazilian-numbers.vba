' Brazilian numbers

Sub BrazilNumsMain()
  Dim C, N As Long
  Debug.Print "First 20 Brazilian numbers:"
  C = 0
  N = 7
  Do While C < 20
    If IsBrazilian(N) Then
      Debug.Print N;
      C = C + 1
    End If
    N = N + 1
  Loop
  Debug.Print
  Debug.Print
  Debug.Print "First 20 odd Brazilian numbers:"
  C = 0
  N = 7
  Do While C < 20
    If IsBrazilian(N) Then
      Debug.Print N;
      C = C + 1
    End If
    N = N + 2
  Loop
  Debug.Print
  Debug.Print
  Debug.Print "First 20 prime Brazilian numbers:"
  C = 0
  N = 7
  Do While C < 20
    If IsBrazilian(N) Then
      Debug.Print N;
      C = C + 1
    End If
    Do
      N = N + 2
    Loop While Not IsPrime(N)
  Loop
  Debug.Print
End Sub

Function IsBrazilian(N As Long) As Boolean
  Dim B As Long
  If N < 7 Then
    IsBrazilian = False
  ElseIf (N Mod 2 = 0) And (N >= 8) Then
    IsBrazilian = True
  Else
    For B = 2 To N - 2
      If SameDigits(N, B) Then
        IsBrazilian = True
        Exit Function
      End If
    Next B
    IsBrazilian = False
  End If
End Function

Function SameDigits(N As Long, B As Long) As Boolean
  ' Result: True if N has same digits in the base B, False otherwise
  Dim NL, F As Long
  NL = N ' Local N
  F = NL Mod B
  NL = NL \ B
  Do While NL > 0
    If NL Mod B <> F Then
      SameDigits = False
      Exit Function
    End If
    NL = NL \ B
  Loop
  SameDigits = True
End Function

Function IsPrime(N As Long) As Boolean
  Dim D As Long
  If N < 2 Then
    IsPrime = False
  ElseIf N Mod 2 = 0 Then
    IsPrime = (N = 2)
  ElseIf N Mod 3 = 0 Then
    IsPrime = (N = 3)
  Else
    D = 5
    Do While D * D <= N
      If N Mod D = 0 Then
        IsPrime = False
        Exit Function
      Else
        D = D + 2
        If N Mod D = 0 Then
          IsPrime = False
          Exit Function
        Else
          D = D + 4
        End If
      End If
    Loop
    IsPrime = True
  End If
End Function
