Function Longest_common_substring(string1 As String, string2 As String) As String
Dim i As Integer, j As Integer, temp As String, result As String
    For i = 1 To Len(string1)
        For j = 1 To Len(string1)
            temp = Mid(string1, i, j)
            If InStr(string2, temp) Then
                If Len(temp) > Len(result) Then result = temp
            End If
        Next
    Next
    Longest_common_substring = result
End Function

Sub MainLCS()
    Debug.Print Longest_common_substring("thisisatest", "testing123testing")
End Sub
