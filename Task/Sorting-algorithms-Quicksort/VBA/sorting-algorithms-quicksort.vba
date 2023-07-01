Public Sub Quick(a() As Variant, last As Integer)
' quicksort a Variant array (1-based, numbers or strings)
Dim aLess() As Variant
Dim aEq() As Variant
Dim aGreater() As Variant
Dim pivot As Variant
Dim naLess As Integer
Dim naEq As Integer
Dim naGreater As Integer

If last > 1 Then
    'choose pivot in the middle of the array
    pivot = a(Int((last + 1) / 2))
    'construct arrays
    naLess = 0
    naEq = 0
    naGreater = 0
    For Each el In a()
      If el > pivot Then
        naGreater = naGreater + 1
        ReDim Preserve aGreater(1 To naGreater)
        aGreater(naGreater) = el
      ElseIf el < pivot Then
        naLess = naLess + 1
        ReDim Preserve aLess(1 To naLess)
        aLess(naLess) = el
      Else
        naEq = naEq + 1
        ReDim Preserve aEq(1 To naEq)
        aEq(naEq) = el
      End If
    Next
    'sort arrays "less" and "greater"
    Quick aLess(), naLess
    Quick aGreater(), naGreater
    'concatenate
    P = 1
    For i = 1 To naLess
      a(P) = aLess(i): P = P + 1
    Next
    For i = 1 To naEq
      a(P) = aEq(i): P = P + 1
    Next
    For i = 1 To naGreater
      a(P) = aGreater(i): P = P + 1
    Next
End If
End Sub

Public Sub QuicksortTest()
Dim a(1 To 26) As Variant

 'populate a with numbers in descending order, then sort
 For i = 1 To 26: a(i) = 26 - i: Next
 Quick a(), 26
 For i = 1 To 26: Debug.Print a(i);: Next
 Debug.Print
 'now populate a with strings in descending order, then sort
 For i = 1 To 26: a(i) = Chr$(Asc("z") + 1 - i) & "-stuff": Next
 Quick a(), 26
 For i = 1 To 26: Debug.Print a(i); " ";: Next
 Debug.Print
End Sub
