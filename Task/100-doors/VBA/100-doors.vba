Sub Rosetta_100Doors()
Dim Door(100) As Boolean, i As Integer, j As Integer
For i = 1 To 100 Step 1
    For j = i To 100 Step i
        Door(j) = Not Door(j)
    Next j
    If Door(i) = True Then
        Debug.Print "Door " & i & " is Open"
    Else
        Debug.Print "Door " & i & " is Closed"
    End If
Next i
End Sub
