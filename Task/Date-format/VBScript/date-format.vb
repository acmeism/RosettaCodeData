'YYYY-MM-DD format
WScript.StdOut.WriteLine Year(Date) & "-" & Right("0" & Month(Date),2) & "-" & Right("0" & Day(Date),2)

'Weekday_Name, Month_Name DD, YYYY format
WScript.StdOut.WriteLine FormatDateTime(Now,1)
