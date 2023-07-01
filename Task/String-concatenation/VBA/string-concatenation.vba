Option Explicit

Sub String_Concatenation()
Dim str1 As String, str2 As String

    str1 = "Rosetta"
    Debug.Print str1
    Debug.Print str1 & " code!"
    str2 = str1 & " code..."
    Debug.Print str2 & " based on concatenation of : " & str1 & " and code..."
End Sub
