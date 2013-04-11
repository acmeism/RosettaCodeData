Public Function BinarySearch(a, value, low, high)
'search for "value" in ordered array a(low..high)
'return index point if found, -1 if not found

  If high < low Then
    BinarySearch = -1 'not found
    Exit Function
  End If
  midd = low + Int((high - low) / 2) ' "midd" because "Mid" is reserved in VBA
  If a(midd) > value Then
    BinarySearch = BinarySearch(a, value, low, midd - 1)
  ElseIf a(midd) < value Then
    BinarySearch = BinarySearch(a, value, midd + 1, high)
  Else
    BinarySearch = midd
  End If
End Function
