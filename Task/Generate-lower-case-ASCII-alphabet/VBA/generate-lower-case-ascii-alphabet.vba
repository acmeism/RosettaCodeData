Option Explicit

Sub Main_Lower_Case_Ascii_Alphabet()
Dim Alpha() As String

    Alpha = Alphabet(97, 122)
    Debug.Print Join(Alpha, ", ")
End Sub

Function Alphabet(FirstAscii As Byte, LastAscii As Byte) As String()
Dim strarrTemp() As String, i&

    ReDim strarrTemp(0 To LastAscii - FirstAscii)
    For i = FirstAscii To LastAscii
        strarrTemp(i - FirstAscii) = Chr(i)
    Next
    Alphabet = strarrTemp
    Erase strarrTemp
End Function
