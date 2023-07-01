Sub SetupPile(a As Integer, b As Integer)
Application.ScreenUpdating = False
For i = 1 To a
For j = 1 To b
Cells(i, j).value = ""
Cells(i, j).Select

With Selection.Borders(xlEdgeLeft)
    .LineStyle = xlContinuous
    .Weight = xlMedium
End With
With Selection.Borders(xlEdgeTop)
    .LineStyle = xlContinuous
    .Weight = xlMedium
End With
With Selection.Borders(xlEdgeBottom)
    .LineStyle = xlContinuous
    .Weight = xlMedium
End With
With Selection.Borders(xlEdgeRight)
    .LineStyle = xlContinuous
    .Weight = xlMedium
End With

With Selection
    .HorizontalAlignment = xlCenter
    .VerticalAlignment = xlCenter
End With

Next j
Next i
Application.ScreenUpdating = True
End Sub


Sub Abelian_Sandpile()
Dim PileWidth As Integer
Dim PileHeight As Integer
Dim FieldArray() As Integer

Debug.Print "Start:" & Now()

'Set Size of Playing Field
PileWidth = 25
PileHeight = 25

ReDim FieldArray(PileWidth - 1, PileHeight - 1)

'Paint Basic Grid
SetupPile PileWidth, PileHeight

'Drop sand amount into middle of playing field
SandDropAmount = 1000
'Get around excel's incorrect rounding
SandDropColumn = Round((PileWidth / 2) + 0.001, 0)
SandDropRow = Round((PileHeight / 2) + 0.001, 0)

Cells(SandDropRow, SandDropColumn) = SandDropAmount
FieldArray(SandDropRow - 1, SandDropColumn - 1) = SandDropAmount

Continue = False

'Check if Pile is already stabilized at the start
For i = 1 To PileWidth 'Col
For j = 1 To PileHeight 'Row
If FieldArray(j - 1, i - 1) > 3 Then Continue = True
Next j
Next i

'While not stabilized
While Continue
For i = 1 To PileWidth
For j = 1 To PileHeight
    If FieldArray(j - 1, i - 1) > 3 Then
    'Reduce by 4
    FieldArray(j - 1, i - 1) = FieldArray(j - 1, i - 1) - 4
    'Increase Neighbours
    't
    If j >= 2 Then FieldArray(j - 2, i - 1) = FieldArray(j - 2, i - 1) + 1
    'r
    If i < PileWidth Then FieldArray(j - 1, i) = FieldArray(j - 1, i) + 1
    'b
    If j < PileHeight Then FieldArray(j, i - 1) = FieldArray(j, i - 1) + 1
    'l
    If i >= 2 Then FieldArray(j - 1, i - 2) = FieldArray(j - 1, i - 2) + 1
    'Next round
    GoTo Nextone
    End If
Next j
Next i

Nextone:

'Check if now stabilized
Continue = False
For i = 1 To PileWidth
For j = 1 To PileHeight
'Paint every step if needed
'Cells(j, i) = FieldArray(j - 1, i - 1)

If FieldArray(j - 1, i - 1) > 3 Then Continue = True
Next j
Next i

Wend

'Print out final step
For i = 1 To PileWidth
For j = 1 To PileHeight
Cells(j, i) = FieldArray(j - 1, i - 1)
Next j
Next i

'Make field square and remove 0
Cells.Select
Selection.ColumnWidth = 2
Selection.RowHeight = 13.5
Selection.Replace What:="0", Replacement:="", LookAt:=xlPart, SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, ReplaceFormat:=False
Range("A1").Select

Range(Cells(1, 1), Cells(PileHeight, PileWidth)).Select

'Conditional Format
Selection.FormatConditions.AddColorScale ColorScaleType:=3
Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
Selection.FormatConditions(1).ColorScaleCriteria(1).Type = xlConditionValueLowestValue
With Selection.FormatConditions(1).ColorScaleCriteria(1).FormatColor
    .Color = 8109667
    .TintAndShade = 0
End With
Selection.FormatConditions(1).ColorScaleCriteria(2).Type = xlConditionValuePercentile
Selection.FormatConditions(1).ColorScaleCriteria(2).value = 50
With Selection.FormatConditions(1).ColorScaleCriteria(2).FormatColor
    .Color = 8711167
    .TintAndShade = 0
End With
Selection.FormatConditions(1).ColorScaleCriteria(3).Type = xlConditionValueHighestValue
With Selection.FormatConditions(1).ColorScaleCriteria(3).FormatColor
    .Color = 7039480
    .TintAndShade = 0
End With
Range("A1").Select

Debug.Print "W,H,A:" & PileWidth & "," & PileHeight & "," & SandDropAmount
Debug.Print "End:" & Now()

End Sub
