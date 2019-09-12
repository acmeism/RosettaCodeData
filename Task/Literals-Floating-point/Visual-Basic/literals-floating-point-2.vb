Option Explicit
Public Declare Function RtlCompareMemory Lib "ntdll.dll" _
  (ByRef Source1 As Any, ByRef Source2 As Any, ByVal Length As Long) As Long

Public Function IsNAN(ByRef d As Double) As Boolean
Dim d1 As Double
    d1 = NaN()
    IsNAN = (RtlCompareMemory(d, d1, 8) = 8)
End Function

Public Function NaN() As Double
    On Error Resume Next ' ignore the error
    NaN = 0 / 0
End Function

Sub Main()
Dim d1 As Double
Dim d2 As Double
    d1 = NaN()
    d2 = d1
    Debug.Assert IsNAN(d2)
    Debug.Print CStr(d2)
End Sub
