Sub ReadCSV()
    Workbooks.Open Filename:="L:\a\input.csv"
    Range("F1").Value = "Sum"
    Range("F2:F5").Formula = "=SUM(A2:E2)"
    ActiveWorkbook.SaveAs Filename:="L:\a\output.csv", FileFormat:=xlCSV
    ActiveWindow.Close
End Sub
