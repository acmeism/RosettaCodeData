#include "windows.bi"

Const WID = 62, HEI = 42, INC = 10

Type coordenada
    As Short x, y
    Declare Constructor (x As Short = 0, y As Short = 0)
    Declare Sub set (x As Short, y As Short)
End Type

Constructor coordenada (x As Short, y As Short)
    this.set(x, y)
End Constructor

Sub coordenada.set (x As Short, y As Short)
    this.x = x
    this.y = y
End Sub

Type winConsole
    As HANDLE conOut, conIn
    Declare Static Function getInstance() As winConsole Ptr
    Declare Sub showCursor (s As Boolean)
    Declare Sub setColor (clr As Ushort)
    Declare Sub setCursor (p As coordenada)
    Declare Sub setSize (w As Integer, h As Integer)
    Declare Sub flush ()
    Declare Sub Kill ()
    Private:
    Declare Constructor ()
End Type

Constructor winConsole ()
    conOut = GetStdHandle(STD_OUTPUT_HANDLE)
    conIn = GetStdHandle(STD_INPUT_HANDLE)
    showCursor(False)
End Constructor

Dim Shared As winConsole Ptr inst = 0

Function winConsole.getInstance() As winConsole Ptr
    If inst = 0 Then inst = New winConsole()
    Return inst
End Function

Sub winConsole.showCursor (s As Boolean)
    Dim As CONSOLE_CURSOR_INFO ci = (1, s)
    SetConsoleCursorInfo(conOut, @ci)
End Sub

Sub winConsole.setColor (clr As Ushort)
    SetConsoleTextAttribute(conOut, clr)
End Sub

Sub winConsole.setCursor (p As coordenada)
    Dim As COORD Pos = (p.x, p.y)
    SetConsoleCursorPosition(conOut, Pos)
End Sub

Sub winConsole.setSize (w As Integer, h As Integer)
    Dim As COORD crd = (w + 1, h + 1)
    SetConsoleScreenBufferSize(conOut, crd)
    Dim As SMALL_RECT rc = (0, 0, WID, HEI)
    SetConsoleWindowInfo(conOut, True, @rc)
End Sub

Sub winConsole.flush ()
    FlushConsoleInputBuffer(conIn)
End Sub

Sub winConsole.kill ()
    Delete inst
End Sub

Type robots
    As winConsole Ptr console
    As Ubyte brd(WID * HEI)
    As Integer robotsCount, score, aliveRobots
    As coordenada cursor
    As Boolean alive
    Declare Constructor ()
    Declare Destructor ()
    Declare Sub play ()
    Private:
    Declare Sub clearBoard ()
    Declare Sub createBoard ()
    Declare Sub displayBoard ()
    Declare Sub getInput ()
    Declare Sub teleport ()
    Declare Sub printScore ()
    Declare Sub execute (x As Integer, y As Integer)
    Declare Sub waitForEnd ()
    Declare Sub moveRobots ()
    Declare Sub checkCollision (x As Integer, y As Integer)
End Type

Constructor robots ()
    console = winConsole.getInstance()
    console->setSize(WID, HEI)
End Constructor

Destructor robots ()
    console->Kill()
End Destructor

Sub robots.play ()
    Dim As String*1 KBD
    Do
        console->showCursor(False)
        robotsCount = 10
        score = 0
        alive = True
        clearBoard()
        cursor.set(Rnd * (WID - 2) + 1, Rnd * (HEI - 2) + 1)
        brd(cursor.x + WID * cursor.y) = Asc("@")
        createBoard()
        Do
            displayBoard()
            getInput()
            If aliveRobots = 0 Then
                robotsCount += INC
                clearBoard()
                brd(cursor.x + WID * cursor.y) = Asc("@")
                createBoard()
            End If
        Loop While alive
        displayBoard()
        console->setCursor(coordenada(0, 24))
        console->setColor(&h07)
        console->setCursor(coordenada(10, 8))
        Print "+----------------------------------------+"
        console->setCursor(coordenada(10, 9))
        Print "|               GAME OVER                |"
        console->setCursor(coordenada(10, 10))
        Print "|           PLAY AGAIN(Y/N) ?            |"
        console->setCursor(coordenada(10, 11))
        Print "+----------------------------------------+"
        console->setCursor(coordenada(39, 10))
        console->showCursor(True)
        console->flush()
        Input " ", KBD
    Loop Until Ucase(KBD) = "N"
End Sub

Sub robots.clearBoard ()
    For y As Integer = 0 To HEI - 1
        For x As Integer = 0 To WID - 1
            brd(x + WID * y) = 32
            If x = 0 Or x = WID - 1 Or y = 0 Or y = HEI - 1 Then
                brd(x + WID * y) = Asc("#")
            End If
        Next
    Next
End Sub

Sub robots.createBoard ()
    aliveRobots = robotsCount
    Dim As Integer a, b, x
    For x = 0 To robotsCount - 1
        Do
            a = Rnd * WID
            b = Rnd * HEI
        Loop While brd(a + WID * b) <> 32
        brd(a + WID * b) = Asc("+")
    Next
    printScore()
End Sub

Sub robots.displayBoard ()
    Dim As Ubyte t
    console->setCursor(coordenada())
    For y As Integer = 0 To HEI - 1
        For x As Integer = 0 To WID - 1
            t = brd(x + WID * y)
            Select Case As Const t
            Case 32: console->setColor(&h00)
            Case Asc("#"): console->setColor(&h09)
            Case Asc("+"): console->setColor(&h0e)
            Case Asc("Å"), Asc("*"): console->setColor(&h0c)
            Case Asc("@"): console->setColor(&h0a)
            End Select
            Print Chr(t);
        Next
        Print
    Next
End Sub

Sub robots.getInput ()
    Do
        If (GetAsyncKeyState(Asc("Q")) And &h8000) And cursor.x > 1 And cursor.y > 1 Then
            execute(-1, -1)
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("W")) And &h8000) And cursor.y > 1 Then
            execute(0, -1)
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("E")) And &h8000) And cursor.x < WID - 2 And cursor.y > 1 Then
            execute(1, -1)
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("A")) And &h8000) And cursor.x > 1 Then
            execute(-1, 0)
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("D")) And &h8000) And cursor.x < WID - 2 Then
            execute(1, 0)
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("Y")) And &h8000) And cursor.x > 1 And cursor.y < HEI - 2 Then
            execute(-1, 1)
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("X")) And &h8000) And cursor.y < HEI - 2 Then
            execute(0, 1)
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("C")) And &h8000) And cursor.x < WID - 2 And cursor.y < HEI - 2 Then
            execute(1, 1)
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("T")) And &h8000) Then
            teleport()
            moveRobots()
            Exit Do
        End If
        If (GetAsyncKeyState(Asc("Z")) And &h8000) Then
            waitForEnd()
            Exit Do
        End If
    Loop
    console->flush()
    printScore()
End Sub

Sub robots.teleport ()
    brd(cursor.x + WID * cursor.y) = 32
    cursor.x = Rnd * (WID - 2) + 1
    cursor.y = Rnd * (HEI - 2) + 1
    Dim As Integer x = cursor.x + WID * cursor.y
    If brd(x) = Asc("*") Or brd(x) = Asc("+") Or brd(x) = Asc("~") Then
        alive = False
        brd(x) = Asc("Å")
    Else
        brd(x) = Asc("@")
    End If
End Sub

Sub robots.printScore ()
    console->setCursor(coordenada(0, HEI))
    console->setColor(&h2a)
    Print "      SCORE: "; score; "      "
End Sub

Sub robots.execute (x As Integer, y As Integer)
    brd(cursor.x + WID * cursor.y) = 32
    cursor.x += x
    cursor.y += y
    brd(cursor.x + WID * cursor.y) = Asc("@")
    moveRobots()
End Sub

Sub robots.waitForEnd ()
    While aliveRobots And alive
        moveRobots()
        displayBoard()
        Sleep(500)
    Wend
End Sub

Sub robots.moveRobots ()
    Dim As Integer x, y, tx, ty
    For y = 0 To HEI - 1
        For x = 0 To WID - 1
            If brd(x + WID * y) <> Asc("+") Then Continue For
            tx = x
            ty = y
            If tx < cursor.x Then tx += 1 Else If tx > cursor.x Then tx -= 1
            If ty < cursor.y Then ty += 1 Else If ty > cursor.y Then ty -= 1
            If tx <> x Or ty <> y Then
                brd(x + WID * y) = 32
                If brd(tx + WID * ty) = 32 Then
                    brd(tx + WID * ty) = Asc("~")
                Else
                    checkCollision(tx, ty)
                End If
            End If
        Next
    Next
    For x = 0 To WID * HEI - 1
        If brd(x) = Asc("~") Then brd(x) = Asc("+")
    Next
End Sub

Sub robots.checkCollision (x As Integer, y As Integer)
    If cursor.x = x And cursor.y = y Then
        alive = False
        brd(x + y * WID) = Asc("Å")
        Return
    End If
    x = x + y * WID
    If brd(x) = Asc("*") Or brd(x) = Asc("+") Or brd(x) = Asc("~") Then
        If brd(x) <> Asc("*") Then
            aliveRobots -= 1
            score += 1
        End If
        brd(x) = Asc("*")
        aliveRobots -= 1
        score += 1
    End If
End Sub

'--- Programa Principal ---
Randomize Timer
SetConsoleTitle("Robots")
Dim As robots g
g.play()
'--------------------------
