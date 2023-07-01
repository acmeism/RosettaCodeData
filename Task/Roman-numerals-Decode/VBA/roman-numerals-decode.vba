Option Explicit

Sub Main_Romans_Decode()
Dim Arr(), i&

    Arr = Array("III", "XXX", "CCC", "MMM", "VII", "LXVI", "CL", "MCC", "IV", "IX", "XC", "ICM", "DCCCXCIX", "CMI", "CIM", "MDCLXVI", "MCMXC", "MMXVII")
    For i = 0 To UBound(Arr)
        Debug.Print Arr(i) & "   >>> " & lngConvert(CStr(Arr(i)))
    Next
End Sub

Function Convert(Letter As String) As Long
Dim Romans(), DecInt(), Pos As Integer

    Romans = Array("M", "D", "C", "L", "X", "V", "I")
    DecInt = Array(1000, 500, 100, 50, 10, 5, 1)
    Pos = -1
    On Error Resume Next
    Pos = Application.Match(Letter, Romans, 0) - 1
    On Error GoTo 0
    If Pos <> -1 Then Convert = DecInt(Pos)
End Function

Function lngConvert(strRom As String) 'recursive function
Dim i As Long, iVal As Integer

    If Len(strRom) = 1 Then
        lngConvert = Convert(strRom)
    Else
        iVal = Convert(Mid(strRom, 1, 1))
        If iVal < Convert(Mid(strRom, 2, 1)) Then iVal = iVal * (-1)
        lngConvert = iVal + lngConvert(Mid(strRom, 2, Len(strRom) - 1))
    End If
End Function
