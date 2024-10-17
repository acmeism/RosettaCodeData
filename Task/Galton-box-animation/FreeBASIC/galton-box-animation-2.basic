Const pegRadius As Integer = 4
Const pegSize As Integer = pegRadius * 2 + 1
Const pegSize2 As Integer = pegSize * 2
Const delay As Integer = 1
Dim Shared As Integer alto, ancho, histogramSize, ball

Sub eventLoop()
    Dim As String event
    Do
        event = Inkey
        If event <> "" Then End
    Loop Until event = ""
End Sub

Sub animateActual(x1 As Single, y1 As Single, x2 As Single, y2 As Single, steps As Integer)
    Dim As Single x, y, xstep, ystep, lastX, lastY
    x = x1
    y = y1
    xstep = (x2 - x1) / steps
    ystep = (y2 - y1) / steps
    For i As Integer = 1 To steps
        lastX = x
        lastY = y
        Circle (x, y), pegRadius, Rgb(255, 0, 0), , , , F
        eventLoop()
        Sleep delay
        Circle (x, y), pegRadius, Rgb(235, 235, 235), , , , F
        eventLoop()
        x += xstep
        y += ystep
    Next
End Sub

Function drawBall(xpos As Integer, ypos As Integer) As Boolean
    Static As Integer ballcounts()
    If xpos > Ubound(ballcounts) Then
        Redim Preserve ballcounts(xpos) As Integer
    End If
    ballcounts(xpos) += 1
    animateActual(xpos, ypos, xpos, alto - ballcounts(xpos) * pegSize, 20)
    Circle (xpos, alto - ballcounts(xpos) * pegSize), pegRadius, Rgb(255, 0, 0), , , , F
    eventLoop()
    Return Iif(ballcounts(xpos) <= histogramSize, True, False)
End Function

Sub animate(x1 As Single, y1 As Single, x2 As Single, y2 As Single)
    animateActual(x1, y1, x2, y1, 4)
    animateActual(x2, y1, x2, y2, 10)
End Sub

Function galton(pegRows As Integer) As Integer
    Dim As Integer i, xpos, ypos, oldX, oldY
    oldX = ancho / 2 - pegSize / 2
    xpos = oldX
    oldY = pegSize * 3
    ypos = oldY
    animateActual(oldX, 0, xpos, ypos, 10)
    For i = 1 To pegRows
        If Int(Rnd * 2) Then
            xpos += pegSize
        Else
            xpos -= pegSize
        End If
        ypos += pegSize2
        animate(oldX, oldY, xpos, ypos)
        oldX = xpos
        oldY = ypos
    Next
    Return drawBall(xpos, ypos)
End Function

Sub setupWindow(numRows As Integer, ballCount As Integer)
    Dim As Integer i, j, xpos, ypos
    ancho = (2 * numRows + 2) * pegSize + 50
    histogramSize = (ballCount + 2) / 3
    If histogramSize > 500 / pegSize Then histogramSize = 500 / pegSize
    alto = ancho + histogramSize * pegSize + 50
    Screenres ancho, alto, 32
    Windowtitle "Galton box"
    Line (0, 0) - Step(ancho, alto), Rgb(235, 235, 235), BF
    For i = 1 To numRows
        ypos = i * pegSize2 + pegSize * 2
        xpos = ancho / 2 - (i - 1) * pegSize - pegSize / 2
        For j = 1 To i
            Circle (xpos, ypos), pegRadius, Rgb(0, 0, 139), , , , F
            xpos += pegSize2
        Next
    Next
    For i As Integer = 1 To numRows
        Line ((numRows - i + 1) * pegSize2 - pegSize / 2 + 24, alto - pegSize - histogramSize * pegSize) - Step(1, histogramSize * pegSize), Rgb(0, 0, 0)
    Next
End Sub

Dim pegRows As Integer = 10
Dim ballCount As Integer
Do
    Input "How many balls to drop? ", ballCount
Loop Until ballCount > 0

Randomize Timer
setupWindow(pegRows, ballCount)
eventLoop()
For ball = 1 To ballCount
    If Not galton(pegRows) Then Exit For
Next

Color Rgb(255, 0, 0), Rgb(235, 235, 235)
Print Spc(5); "Ended after "; Str(ball-1); " balls"

Do: eventLoop(): Loop
