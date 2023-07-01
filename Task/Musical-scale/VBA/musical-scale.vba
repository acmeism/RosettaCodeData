Option Explicit

Declare Function Beep Lib "kernel32" (ByVal Freq As Long, ByVal Dur As Long) As Long

Sub Musical_Scale()
Dim Fqs, i As Integer
   Fqs = Array(264, 297, 330, 352, 396, 440, 495, 528)
   For i = LBound(Fqs) To UBound(Fqs)
      Beep Fqs(i), 500
   Next
End Sub
