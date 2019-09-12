Option Explicit

Private Declare Sub GetMem8 Lib "msvbvm60.dll" _
  (ByVal SrcAddr As Long, ByVal TarAddr As Long)

Sub Main()
Dim PlusInfinity As Double
Dim MinusInfinity As Double
Dim IndefiniteNumber As Double
    On Error Resume Next
    PlusInfinity = 1 / 0
    MinusInfinity = -1 / 0
    IndefiniteNumber = 0 / 0
    Debug.Print "PlusInfinity     = " & CStr(PlusInfinity) _
      & "  (" & DoubleAsHex(PlusInfinity) & ")"
    Debug.Print "MinusInfinity    = " & CStr(MinusInfinity) _
      & " (" & DoubleAsHex(MinusInfinity) & ")"
    Debug.Print "IndefiniteNumber = " & CStr(IndefiniteNumber) _
      & " (" & DoubleAsHex(IndefiniteNumber) & ")"
End Sub

Function DoubleAsHex(ByVal d As Double) As String
Dim l(0 To 1) As Long
GetMem8 VarPtr(d), VarPtr(l(0))
DoubleAsHex = Right$(String$(8, "0") & Hex$(l(1)), 8) _
            & Right$(String$(8, "0") & Hex$(l(0)), 8)
End Function
