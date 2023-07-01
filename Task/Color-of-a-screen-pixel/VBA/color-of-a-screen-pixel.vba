Option Explicit

Private Type POINTAPI
    x As Long
    y As Long
End Type

Private Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function GetCursorPos Lib "USER32" (lpPoint As POINTAPI) As Long
Private Declare Function GetWindowDC Lib "USER32" (ByVal hWnd As Long) As Long

Sub Color_of_a_screen_pixel()
Dim myColor As Long
    myColor = Get_Color_Under_Cursor
End Sub

Function Get_Color_Under_Cursor() As Long
Dim Pos As POINTAPI, lngDc As Long

    lngDc = GetWindowDC(0)
    GetCursorPos Pos
    Get_Color_Under_Cursor = GetPixel(lngDc, Pos.x, Pos.y)
End Function
