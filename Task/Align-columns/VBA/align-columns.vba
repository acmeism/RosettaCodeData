Public Sub TestSplit(Optional align As String = "left", Optional spacing As Integer = 1)
  Dim word() As String
  Dim colwidth() As Integer
  Dim ncols As Integer
  Dim lines(6) As String
  Dim nlines As Integer

  'check arguments
  If Not (align = "left" Or align = "right" Or align = "center") Then
    MsgBox "TestSplit: wrong argument 'align': " & align
    Exit Sub
  End If
  If spacing < 0 Then
    MsgBox "TestSplit: wrong argument: 'spacing' cannot be negative."
    Exit Sub
  End If

  ' Sample Input (should be from a file)
  nlines = 6
  lines(1) = "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
  lines(2) = "are$delineated$by$a$single$'dollar'$character,$write$a$program"
  lines(3) = "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
  lines(4) = "column$are$separated$by$at$least$one$space."
  lines(5) = "Further,$allow$for$each$word$in$a$column$to$be$either$left$"
  lines(6) = "justified,$right$justified,$or$center$justified$within$its$column."

  'first pass: count columns and column widths
  'the words are not kept in memory
  ncols = -1
  For l = 1 To nlines
    word = Split(RTrim(lines(l)), "$")
    If UBound(word) > ncols Then
      ncols = UBound(word)
      ReDim Preserve colwidth(ncols)
    End If
    For i = 0 To UBound(word)
      If Len(word(i)) > colwidth(i) Then colwidth(i) = Len(word(i))
    Next i
  Next l

  'discard possibly empty columns at the right
  '(this assumes there is at least one non-empty column)
  While colwidth(ncols) = 0
    ncols = ncols - 1
  Wend

  'second pass: print in columns
  For l = 1 To nlines
    word = Split(RTrim(lines(l)), "$")
    For i = 0 To UBound(word)
      a = word(i)
      w = colwidth(i)
      If align = "left" Then
        Debug.Print a + String$(w - Len(a), " ");
      ElseIf align = "right" Then
        Debug.Print String$(w - Len(a), " ") + a;
      ElseIf align = "center" Then
        d = Int((w - Len(a)) / 2)
        Debug.Print String$(d, " ") + a + String$(w - (d + Len(a)), " ");
      End If
      If i < ncols Then Debug.Print Spc(spacing);
    Next i
    Debug.Print
  Next l
End Sub
