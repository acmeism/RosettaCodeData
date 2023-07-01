Option Explicit

Sub Main_File_Exists()
Dim myFile As String, myDirectory As String

    myFile = "Abdu'l-Bahá.txt"
    myDirectory = "C:\"
    Debug.Print File_Exists(myFile, myDirectory)
End Sub

Function File_Exists(F As String, D As String) As Boolean
    If F = "" Then
        File_Exists = False
    Else
        D = IIf(Right(D, 1) = "\", D, D & "\")
        File_Exists = (Dir(D & F) <> "")
    End If
End Function
