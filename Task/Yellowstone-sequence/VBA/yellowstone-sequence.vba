Function gcd(a As Long, b As Long) As Long
    If b = 0 Then
        gcd = a
        Exit Function
    End If
    gcd = gcd(b, a Mod b)
End Function

Sub Yellowstone()
Dim i As Long, j As Long, k As Long, Y(1 To 30) As Long

Y(1) = 1
Y(2) = 2
Y(3) = 3

For i = 4 To 30
  k = 3
  Do
      k = k + 1
      If gcd(k, Y(i - 2)) = 1 Or gcd(k, Y(i - 1)) > 1 Then GoTo EndLoop:
      For j = 1 To i - 1
          If Y(j) = k Then GoTo EndLoop:
      Next j
      Y(i) = k
      Exit Do
EndLoop:
  Loop
Next i

For i = 1 To 30
    Debug.Print Y(i) & " ";
Next i
End Sub
