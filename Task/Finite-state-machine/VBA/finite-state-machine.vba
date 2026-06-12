Enum states
    READY
    WAITING
    DISPENSE
    REFUND
    QU1T
End Enum '-- (or just use strings if you prefer)
Public Sub finite_state_machine()
    Dim state As Integer: state = READY: ch = " "
    Do While True
        Debug.Print ch
        Select Case state
            Case READY:     Debug.Print "Machine is READY. (D)eposit or (Q)uit :"
                            Do While True
                                If ch = "D" Then
                                    state = WAITING
                                    Exit Do
                                End If
                                If ch = "Q" Then
                                    state = QU1T
                                    Exit Do
                                End If
                                ch = InputBox("Machine is READY. (D)eposit or (Q)uit :")
                            Loop
            Case WAITING:   Debug.Print "(S)elect product or choose to (R)efund :"
                            Do While True
                                If ch = "S" Then
                                    state = DISPENSE
                                    Exit Do
                                End If
                                If ch = "R" Then
                                    state = REFUND
                                    Exit Do
                                End If
                                ch = InputBox("(S)elect product or choose to (R)efund :")
                            Loop
            Case DISPENSE:  Debug.Print "Dispensing product..."
                            Do While True
                                If ch = "C" Then
                                    state = READY
                                    Exit Do
                                End If
                                ch = InputBox("Please (C)ollect product. :")
                            Loop
            Case REFUND:    Debug.Print "Please collect refund."
                            state = READY
                            ch = " "
            Case QU1T:      Debug.Print "Thank you, shutting down now."
                            Exit Sub
        End Select
    Loop
End Sub
