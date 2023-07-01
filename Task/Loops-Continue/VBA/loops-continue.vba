Public Sub LoopContinue()
    Dim value As Integer
    For value = 1 To 10
        Debug.Print value;
        If value Mod 5 = 0 Then
            'VBA does not have a continue statement
            Debug.Print
        Else
            Debug.Print ",";
        End If
    Next value
End Sub
