Public iSide As Integer
Public iSize As Integer
Public iGrid() As Integer
Public lMoves As Long
Public sMessage As String
Public Const sTitle As String = "Tile Puzzle"


Sub PlayGame()
    Dim iNum As Integer
    Dim i As Integer
    Dim vInput As Variant

DefineGrid:
    vInput = InputBox("Enter size of grid, as a whole number" & String(2, vbCr) & "(e.g. for a 4 x 4 grid, enter '4')", sTitle, 4)
    If vInput = "" Then Exit Sub
    If Not IsNumeric(vInput) Then GoTo DefineGrid
    iSide = vInput
    If iSide < 3 Or iNum > 10 Then GoTo DefineGrid
    iSize = iSide ^ 2
    ReDim iGrid(1 To iSize)

Initalize:
    InitializeGrid
    If Not IsSolvable Then GoTo Initalize

GetInput:
    vInput = InputBox(ShowGrid & vbCr & "Enter number to move into empty tile", sTitle)
    If vInput = "" Then
        If MsgBox("Are you sure? This will end the current game.", vbExclamation + vbYesNo, sTitle) = vbYes Then Exit Sub
    End If
    If Not IsNumeric(vInput) Then
        sMessage = "'" & vInput & "' is not a valid tile"
        GoTo GetInput
    End If
    iNum = vInput
    If iNum < 1 Or iNum > iSize - 1 Then
        sMessage = iNum & " is not a valid tile"
        GoTo GetInput
    End If
    i = FindTile(iNum)
    If Not ValidMove(i) Then GoTo GetInput
    MoveTile (i)
    If TestGrid Then
        MsgBox "SUCCESS! You solved the puzzle in " & lMoves & " moves", vbInformation + vbOKOnly, sTitle
    Else
        GoTo GetInput
    End If
End Sub

Function RandomTile() As Integer
    Randomize
    RandomTile = Int(Rnd * iSize) + 1
End Function

Function GetX(ByVal i As Integer) As Integer
    GetX = Int((i - 1) / iSide) + 1
End Function

Function GetY(ByVal i As Integer) As Integer
    GetY = (i - 1) Mod iSide + 1
End Function

Function GetI(ByVal x As Integer, y As Integer)
    GetI = (x - 1) * iSide + y
End Function

Function InitializeGrid()
    Dim i As Integer
    Dim x As Integer
    Dim y As Integer

    sMessage = "New " & iSide & " x " & iSide & " game started" & vbCr

    For i = 1 To iSize
        iGrid(i) = 0
    Next i
    For i = 1 To iSize - 1
        Do
            x = RandomTile
            If iGrid(x) = 0 Then iGrid(x) = i
        Loop Until iGrid(x) = i
    Next i
    lMoves = 0
End Function

Function IsSolvable() As Boolean
    Dim i As Integer
    Dim j As Integer
    Dim iCount As Integer
    For i = 1 To iSize - 1
        For j = i + 1 To iSize
            If iGrid(j) < iGrid(i) And iGrid(j) > 0 Then iCount = iCount + 1
        Next j
    Next i
    If iSide Mod 2 Then
        IsSolvable = Not iCount Mod 2
    Else
        IsSolvable = iCount Mod 2 = GetX(FindTile(0)) Mod 2
    End If
End Function

Function TestGrid() As Boolean
    Dim i As Integer

    For i = 1 To iSize - 1
        If Not iGrid(i) = i Then
            TestGrid = False
            Exit Function
        End If
    Next i
    TestGrid = True
End Function

Function FindTile(ByVal iNum As Integer) As Integer
    Dim i As Integer
    For i = 1 To iSize
        If iGrid(i) = iNum Then
            FindTile = i
            Exit Function
        End If
    Next i
End Function

Function ValidMove(ByVal i As Integer) As Boolean
    Dim e As Integer
    Dim xDiff As Integer
    Dim yDiff As Integer

    e = FindTile(0)
    xDiff = GetX(i) - GetX(e)
    yDiff = GetY(i) - GetY(e)
    If xDiff = 0 Then
        If yDiff = 1 Then
            sMessage = "Tile " & iGrid(i) & " was moved left"
            ValidMove = True
        ElseIf yDiff = -1 Then
            sMessage = "Tile " & iGrid(i) & " was moved right"
            ValidMove = True
        End If
    ElseIf yDiff = 0 Then
        If xDiff = 1 Then
            sMessage = "Tile " & iGrid(i) & " was moved up"
            ValidMove = True
        ElseIf xDiff = -1 Then
            sMessage = "Tile " & iGrid(i) & " was moved down"
            ValidMove = True
        End If
    End If
    If Not ValidMove Then sMessage = "Tile " & iGrid(i) & " may not be moved"
End Function

Function MoveTile(ByVal i As Integer)
    Dim e As Integer
    e = FindTile(0)
    iGrid(e) = iGrid(i)
    iGrid(i) = 0
    lMoves = lMoves + 1
End Function

Function ShowGrid()
    Dim x As Integer
    Dim y As Integer
    Dim i As Integer
    Dim sNum As String
    Dim s As String

    For x = 1 To iSide
        For y = 1 To iSide
            sNum = iGrid(GetI(x, y))
            If sNum = "0" Then sNum = ""
            s = s & sNum & vbTab
        Next y
        s = s & vbCr
    Next x
    If Not sMessage = "" Then
        s = s & vbCr & sMessage & vbCr
    End If
    ShowGrid = s
End Function
