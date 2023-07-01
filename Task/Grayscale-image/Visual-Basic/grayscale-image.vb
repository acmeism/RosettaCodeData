Option Explicit

Private Type BITMAP
  bmType As Long
  bmWidth As Long
  bmHeight As Long
  bmWidthBytes As Long
  bmPlanes As Integer
  bmBitsPixel As Integer
  bmBits As Long
End Type

Private Type RGB
  Red As Byte
  Green As Byte
  Blue As Byte
  Alpha As Byte
End Type

Private Type RGBColor
  Color As Long
End Type

Public Declare Function CreateCompatibleDC Lib "gdi32.dll" (ByVal hdc As Long) As Long
Public Declare Function GetObjectA Lib "gdi32.dll" (ByVal hObject As Long, ByVal nCount As Long, ByRef lpObject As Any) As Long
Public Declare Function SelectObject Lib "gdi32.dll" (ByVal hdc As Long, ByVal hObject As Long) As Long
Public Declare Function GetPixel Lib "gdi32.dll" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Public Declare Function SetPixel Lib "gdi32.dll" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Public Declare Function DeleteDC Lib "gdi32.dll" (ByVal hdc As Long) As Long


Sub Main()
Dim p As stdole.IPictureDisp
Dim hdc As Long
Dim bmp As BITMAP
Dim i As Long, x As Long, y As Long
Dim tRGB As RGB, cRGB As RGBColor

Set p = VB.LoadPicture("T:\TestData\Input_Colored.bmp")
GetObjectA p.Handle, Len(bmp), bmp

hdc = CreateCompatibleDC(0)
SelectObject hdc, p.Handle

For x = 0 To bmp.bmWidth - 1
  For y = 0 To bmp.bmHeight - 1
    cRGB.Color = GetPixel(hdc, x, y)
    LSet tRGB = cRGB
    i = (0.2126 * tRGB.Red + 0.7152 * tRGB.Green + 0.0722 * tRGB.Blue)
    SetPixel hdc, x, y, RGB(i, i, i)
  Next y
Next x

VB.SavePicture p, "T:\TestData\Output_GrayScale.bmp"
DeleteDC hdc

End Sub
