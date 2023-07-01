Public Sub ascii()
    Dim s As String, i As Integer, j As Integer
    For i = 0 To 15
        For j = 32 + i To 127 Step 16
            Select Case j
                Case 32: s = "Spc"
                Case 127: s = "Del"
                Case Else: s = Chr(j)
            End Select
            Debug.Print Tab(10 * (j - 32 - i) / 16); Spc(3 - Len(CStr(j))); j & ": " & s;
        Next j
        Debug.Print vbCrLf
    Next i
End Sub
