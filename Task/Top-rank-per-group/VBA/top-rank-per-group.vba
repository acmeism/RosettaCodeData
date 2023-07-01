Private Sub top_rank(filename As String, n As Integer)
    Workbooks.OpenText filename:=filename, Comma:=True
    Dim ws As Worksheet
    Set ws = Sheets.Add: ws.Name = "output"
    ActiveWorkbook.PivotCaches.Create(SourceType:=xlDatabase, SourceData:= _
        "data!R1C1:R14C4", Version:=6).CreatePivotTable TableDestination:= _
        "output!R3C1", TableName:="TableName", DefaultVersion:=6
    With Sheets("output").PivotTables("TableName")
        .InGridDropZones = True
        .RowAxisLayout xlTabularRow
        .AddDataField Sheets("output").PivotTables("TableName"). _
                PivotFields("Salary"), "Top rank", xlSum
        .PivotFields("Department").Orientation = xlRowField
        .PivotFields("Department").Position = 1
        .PivotFields("Salary").Orientation = xlRowField
        .PivotFields("Salary").Position = 2
        .PivotFields("Employee Name").Orientation = xlRowField
        .PivotFields("Employee Name").Position = 3
        .PivotFields("Employee ID").Orientation = xlRowField
        .PivotFields("Employee ID").Position = 4
        .PivotFields("Salary").PivotFilters.Add2 Type:=xlTopCount, _
            DataField:=Sheets("output").PivotTables("TableName"). _
            PivotFields("Top rank"), Value1:=n
        .PivotFields("Salary").Subtotals = Array(False, False, False, False, _
            False, False, False, False, False, False, False, False)
        .PivotFields("Employee Name").Subtotals = Array(False, False, False, _
            False, False, False, False, False, False, False, False, False)
        .PivotFields("Department").Subtotals = Array(False, False, False, False, _
            False, False, False, False, False, False, False, False)
        .ColumnGrand = False
        .PivotFields("Salary").AutoSort xlDescending, "Salary"
    End With
End Sub

Public Sub main()
    top_rank filename:="D:\data.txt", n:=3
End Sub
