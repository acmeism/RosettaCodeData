Public Function BinarySearch2(a, value)
'search for "value" in array a
'return index point if found, -1 if not found

  low = LBound(a)
  high = UBound(a)
  Do While low <= high
    midd = low + Int((high - low) / 2)
    If a(midd) = value Then
      BinarySearch2 = midd
      Exit Function
    ElseIf a(midd) > value Then
      high = midd - 1
    Else
      low = midd + 1
    End If
 Loop
 BinarySearch2 = -1 'not found
End Function
