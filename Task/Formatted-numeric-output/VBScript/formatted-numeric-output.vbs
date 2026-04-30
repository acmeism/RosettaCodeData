a = 1234.5678

' Round to three decimal places. Groups by default. Output = "1,234.568".
WScript.Echo FormatNumber(a, 3)

' Truncate to three decimal places. Output = "1234.567".
WScript.Echo Left(a, InStr(a, ".") + 3)

' Round to a whole number. Grouping disabled. Output = "1235".
WScript.Echo FormatNumber(a, 0, , , False)

' Use integer portion only and pad with zeroes to fill 8 chars. Output = "00001234".
WScript.Echo Right("00000000" & Int(a), 8)
