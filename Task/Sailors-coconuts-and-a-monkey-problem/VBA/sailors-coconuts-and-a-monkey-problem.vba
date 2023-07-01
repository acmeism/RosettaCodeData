Option Explicit
Public Sub coconuts()
    Dim sailors As Integer
    Dim share As Long
    Dim finalshare As Integer
    Dim minimum As Long, pile As Long
    Dim i As Long, j As Integer
    Debug.Print "Sailors", "Pile", "Final share"
    For sailors = 2 To 6
        i = 1
        Do While True
            pile = i
            For j = 1 To sailors
                If (pile - 1) Mod sailors <> 0 Then Exit For
                share = (pile - 1) / sailors
                pile = pile - share - 1
            Next j
            If j > sailors Then
                If share Mod sailors = 0 And share > 0 Then
                    minimum = i
                    finalshare = pile / sailors
                    Exit Do
                End If
            End If
            i = i + 1
        Loop
        Debug.Print sailors, minimum, finalshare
    Next sailors
End Sub
