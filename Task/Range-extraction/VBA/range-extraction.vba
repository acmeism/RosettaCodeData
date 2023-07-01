Public Function RangeExtraction(AList) As String
'AList is a variant that is an array, assumed filled with numbers in ascending order
Const RangeDelim = "-"          'range delimiter
Dim result As String
Dim InRange As Boolean
Dim Posn, ub, lb, rangestart, rangelen As Integer

result = ""
'find dimensions of AList
ub = UBound(AList)
lb = LBound(AList)
Posn = lb
While Posn < ub
  rangestart = Posn
  rangelen = 0
  InRange = True
  'try to extend the range
  While InRange
    rangelen = rangelen + 1
    If Posn = ub Then
      InRange = False
    Else
      InRange = (AList(Posn + 1) = AList(Posn) + 1)
      Posn = Posn + 1
    End If
  Wend
  If rangelen > 2 Then 'output the range if it has more than 2 elements
    result = result & "," & Format$(AList(rangestart)) & RangeDelim & Format$(AList(rangestart + rangelen - 1))
  Else 'output the separate elements
    For i = rangestart To rangestart + rangelen - 1
      result = result & "," & Format$(AList(i))
    Next
  End If
  Posn = rangestart + rangelen
Wend
RangeExtraction = Mid$(result, 2) 'get rid of first comma!
End Function


Public Sub RangeTest()
'test function RangeExtraction
'first test with a Variant array
Dim MyList As Variant
MyList = Array(0, 1, 2, 4, 6, 7, 8, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39)
Debug.Print "a) "; RangeExtraction(MyList)

'next test with an array of integers
Dim MyOtherList(1 To 20) As Integer
MyOtherList(1) = -6
MyOtherList(2) = -3
MyOtherList(3) = -2
MyOtherList(4) = -1
MyOtherList(5) = 0
MyOtherList(6) = 1
MyOtherList(7) = 3
MyOtherList(8) = 4
MyOtherList(9) = 5
MyOtherList(10) = 7
MyOtherList(11) = 8
MyOtherList(12) = 9
MyOtherList(13) = 10
MyOtherList(14) = 11
MyOtherList(15) = 14
MyOtherList(16) = 15
MyOtherList(17) = 17
MyOtherList(18) = 18
MyOtherList(19) = 19
MyOtherList(20) = 20
Debug.Print "b) "; RangeExtraction(MyOtherList)
End Sub
