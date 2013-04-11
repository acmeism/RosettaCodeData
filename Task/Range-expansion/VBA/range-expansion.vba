Public Function RangeExpand(AString as string)
' return a list with the numbers expressed in AString
Dim Splits() As String
Dim List() As Integer
Dim count As Integer

count = -1 'to start a zero-based List() array
' first split it using comma as delimiter
Splits = Split(AString, ",")
' process all fragments
For Each fragment In Splits
  'is there a "-" in it (do not consider first character)?
  P = InStr(2, fragment, "-")
  If P > 0 Then 'yes, so it's a range: find start and end numbers
    nstart = Val(left$(fragment, P - 1))
    nend = Val(Mid$(fragment, P + 1))
    j = count
    count = count + (nend - nstart + 1)
    'add numbers in range to List
    ReDim Preserve List(count)
    For i = nstart To nend
      j = j + 1
      List(j) = i
    Next
  Else
    'not a range, add a single number
    count = count + 1
    ReDim Preserve List(count)
    List(count) = Val(fragment)
  End If
Next
RangeExpand = List
End Function

Public Sub RangeExpandTest()
'test function RangeExpand
Dim X As Variant

X = RangeExpand("-6,-3--1,3-5,7-11,14,15,17-20")
'print X
Debug.Print "Result:"
For Each el In X
  Debug.Print el;
Next
Debug.Print
End Sub
