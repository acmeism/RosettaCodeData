Public lastsquare As Long
Public nextsquare As Long
Public lastcube As Long
Public midcube As Long
Public nextcube As Long
Private Sub init()
    lastsquare = 1
    nextsquare = -1
    lastcube = -1
    midcube = 0
    nextcube = 1
End Sub

Private Function squares() As Long
    lastsquare = lastsquare + nextsquare
    nextsquare = nextsquare + 2
    squares = lastsquare
End Function

Private Function cubes() As Long
    lastcube = lastcube + nextcube
    nextcube = nextcube + midcube
    midcube = midcube + 6
    cubes = lastcube
End Function

Public Sub main()
    init
    cube = cubes
    For i = 1 To 30
        Do While True
            square = squares
            Do While cube < square
                cube = cubes
            Loop
            If square <> cube Then
                Exit Do
            End If
        Loop
        If i > 20 Then
            Debug.Print square;
        End If
    Next i
End Sub
