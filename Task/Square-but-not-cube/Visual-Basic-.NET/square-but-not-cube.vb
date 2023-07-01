Module Module1

  ' flag / mask explanation:
  '  bit 0 (1) = increment square
  '  bit 1 (2) = increment cube
  '  bit 2 (4) = has output

  ' Checks flag against mask, then advances mask.
  Function ChkFlg(flag As Integer, ByRef mask As Integer) As Boolean
    ChkFlg = (flag And mask) = mask : mask <<= 1
  End Function

  Sub SwoC(limit As Integer)
    Dim count, square, delta, cube, d1, d2, flag, mask As Integer, s as string = ""
    count = 1 : square = 1 : delta = 1 : cube = 1 : d1 = 1 : d2 = 0
    While count <= limit
      flag = {5, 7, 2}(1 + square.CompareTo(cube))
      If flag = 7 Then s = String. Format("   {0} (also cube)", square)
      If flag = 5 Then s = String.Format("{0,-2} {1}", count, square) : count += 1
      mask = 1 : If ChkFlg(flag, mask) Then delta += 2 : square += delta
      If ChkFlg(flag, mask) Then d2 += 6 : d1 += d2 : cube += d1
      If ChkFlg(flag, mask) Then Console.WriteLine(s)
    End While
  End Sub

  Sub Main()
    SwoC(30)
  End Sub

End Module
