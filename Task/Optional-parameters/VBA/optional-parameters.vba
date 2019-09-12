Private Sub optional_parameters(theRange As String, _
        Optional ordering As Integer = 0, _
        Optional column As Integer = 1, _
        Optional reverse As Integer = 1)
    ActiveSheet.Sort.SortFields.Clear
    ActiveSheet.Sort.SortFields.Add _
        Key:=Range(theRange).Columns(column), _
        SortOn:=SortOnValues, _
        Order:=reverse, _
        DataOption:=ordering 'the optional parameter ordering and above reverse
    With ActiveSheet.Sort
        .SetRange Range(theRange)
        .Header = xlGuess
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
End Sub
Public Sub main()
    'Sort the strings in the active sheet in Excel
    'Supply the range of cells to be sorted
    'Optionally specify ordering, default is 0,
    'which is normal sort, text and data separately;
    'ordering:=1 treats text as numeric data.
    'Optionally specify column number, default is 1
    'Optionally specify reverse, default is 1
    'which sorts in ascending order.
    'Specifying reverse:=2 will sort in descending order.
    optional_parameters theRange:="A1:C4", ordering:=1, column:=2, reverse:=1
End Sub
