Public Sub testBinarySearch(n)
Dim a(1 To 100)
'create an array with values = multiples of 10
For i = 1 To 100: a(i) = i * 10: Next
Debug.Print BinarySearch(a, n, LBound(a), UBound(a))
End Sub

Public Sub stringtestBinarySearch(w)
'uses BinarySearch with a string array
Dim a
a = Array("AA", "Maestro", "Mario", "Master", "Mattress", "Mister", "Mistress", "ZZ")
Debug.Print BinarySearch(a, w, LBound(a), UBound(a))
End Sub
