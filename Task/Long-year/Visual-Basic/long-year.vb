Option Explicit

Function IsLongYear(ByVal Year As Integer) As Boolean
  Select Case vbThursday
  Case VBA.DatePart("w", VBA.DateSerial(Year, 1, 1)), _
       VBA.DatePart("w", VBA.DateSerial(Year, 12, 31))
    IsLongYear = True
  End Select
End Function

Sub Main()
'test
Dim l As Long
  For l = 1990 To 2021
    Select Case l
    Case 1992, 1998, 2004, 2009, 2015, 2020
      Debug.Assert IsLongYear(l)
    Case Else
      Debug.Assert Not IsLongYear(l)
    End Select
  Next l
End Sub
