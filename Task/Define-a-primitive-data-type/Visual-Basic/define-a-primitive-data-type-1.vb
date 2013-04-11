Private mvarValue As Integer

Public Property Let Value(ByVal vData As Integer)
    If (vData > 10) Or (vData < 1) Then
        Error 380   'Invalid property value; could also use 6, Overflow
    Else
        mvarValue = vData
    End If
End Property

Public Property Get Value() As Integer
    Value = mvarValue
End Property

Private Sub Class_Initialize()
    'vb defaults to 0 for numbers; let's change that...
    mvarValue = 1
End Sub
