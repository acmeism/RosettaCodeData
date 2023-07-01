Option Explicit

Sub Method_1(Optional myStr As String)
Dim strTemp As String
    If myStr <> "" Then strTemp = myStr
    Debug.Print strTemp
End Sub

Static Sub Method_2(Optional myStr As String)
Dim strTemp As String
    If myStr <> "" Then strTemp = myStr
    Debug.Print strTemp
End Sub
