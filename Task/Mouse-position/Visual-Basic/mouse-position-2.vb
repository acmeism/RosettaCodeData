Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long

Private Type POINTAPI
    'X and Y are in pixels, with (0,0) being the top left corner of the primary display
    X As Long
    Y As Long
End Type

Private Pt As POINTAPI

Private Sub Timer1_Timer()
    GetCursorPos Pt
    Me.Cls
    Me.Print "X:" & Pt.X
    Me.Print "Y:" & Pt.Y
End Sub
