Public Function IsLeapYear1(ByVal theYear As Integer) As Boolean
'this function utilizes documented behaviour of the built-in DateSerial function
IsLeapYear1 = (VBA.Day(VBA.DateSerial(theYear, 2, 29)) = 29)
End Function

Public Function IsLeapYear2(ByVal theYear As Integer) As Boolean
'this function uses the well-known formula
IsLeapYear2 = IIf(theYear Mod 100 = 0, theYear Mod 400 = 0, theYear Mod 4 = 0)
End Function
