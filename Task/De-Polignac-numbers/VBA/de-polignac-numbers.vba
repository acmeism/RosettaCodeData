' De Polignac numbers

Const MaxNumber = 500000
Const MaxPower = 20

Sub PolignacMain()
  Dim PowersOf2(MaxPower) As Long
  Dim Prime(MaxNumber) As Boolean
  ' Sieve the primes to MaxNumber
  Prime(0) = False
  Prime(1) = False
  Prime(2) = True
  For I = 3 To MaxNumber Step 2
    Prime(I) = True
  Next I
  For I = 4 To MaxNumber Step 2
    Prime(I) = False
  Next I
  For I = 3 To Int(Sqr(MaxNumber)) Step 2
    If Prime(I) Then
      S = I * I
      DoublI = I + I
      Do While S <= MaxNumber
        Prime(S) = False
        S = S + DoublI
      Loop
    End If
  Next I
  ' Table of powers of 2 greater than 2^0 (up to around 2000000)
  ' Increase the table size if MaxNumber > 2000000
  P2 = 1
  For I = 1 To MaxPower
    P2 = P2 * 2
    PowersOf2(I) = P2
  Next I
  ' The numbers must be odd and not of the form P + 2^N
  ' either P is odd and 2^N is even and hence N > 0 and P > 2
  ' or 2^N is odd and P is even and hence N = 0 and P = 2
  ' (the only even prime is 2, the only odd 2^N is 1).
  ' N = 0, P = 2
  DpCount = 1
  Debug.Print FormatLong(1, 5);
  ' N > 0, P > 2
  For I = 5 To MaxNumber Step 2
    Found = False
    P = 1
    Do While P <= MaxPower And (Found = False And I > PowersOf2(P))
      Found = Prime(I - PowersOf2(P))
      P = P + 1
    Loop
    If Found = False Then
      DpCount = DpCount + 1
      If DpCount <= 50 Then
        Debug.Print FormatLong(I, 5);
        If DpCount Mod 10 = 0 Then Debug.Print
      ElseIf DpCount = 1000 Or DpCount = 10000 Then
        Debug.Print "The "; FormatLong(DpCount, 5); "th de Polignac number is "; FormatLong(I, 7)
      End If
    End If
  Next I
  Debug.Print "Found"; DpCount; "de Polignac numbers up to"; MaxNumber
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
