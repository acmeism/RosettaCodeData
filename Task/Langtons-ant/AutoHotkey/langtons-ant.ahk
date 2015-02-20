#NoEnv
SetBatchLines, -1
; Directions
Directions := {0: "North", 1: "East", 2: "South", 3: "West"}
; Initialize the plane (set all cells to white)
White := 0xFFFFFF
Plane := []
PW := PH := 100
loop, % PH {
    I := A_Index
    loop, % PW
        Plane[I, A_Index] := White
}
; Let it run
DI := D := 0 ; initial direction
X := Y := 50 ; initial coordinates
while (X > 0) && (X <= PW) && (Y > 0) && (Y <= PH) {
    D := (D + ((Plane[X, Y] ^= White) ? 1 : 3)) & 3
    if (D & 1)
        X += -(D = 3) + (D = 1)
    else
        Y += -(D = 0) + (D = 2)
}
; Show the result
HBM := CreateDIB(Plane, PW, PH, 400, 400, 0)
Gui, Margin, 0, 0
Gui, Add, Text, x0 y0 w20 h440 Center 0x200, W
Gui, Add, Text, x20 y0 w400 h20 Center 0x200, N
Gui, Add, Picture, x20 y20 w400 h400 0x4E hwndHPIC ; SS_REALSIZECONTROL = 0x40 | SS_BITMAP = 0xE
DllCall("User32.dll\SendMessage", "Ptr", HPIC, "UInt", 0x172, "Ptr", 0, "Ptr", HBM) ; STM_SETIMAGE = 0x172
Gui, Add, Text, xp+5 yp h20 0x200 BackgroundTrans, % "Initial direction: " . Directions[DI]
Gui, Add, Text, x20 y420 w400 h20 Center 0x200, S
Gui, Add, Text, x420 y0 w20 h440 Center 0x200, E
Gui, Show, , Langton's ant (%PW%x%PH%)
Return

GuiClose:
ExitApp

CreateDIB(PixelArray, PAW, PAH, BMW := 0, BMH := 0, Gradient := 1) { ; SKAN, 01-Apr-2014 / array version by just me
    SLL := (PAW * 3) + (PAW & 1)
    VarSetCapacity(BMBITS, SLL * PAH, 0)
    P := &BMBITS
    loop, % PAH {
        R := A_Index
        loop, % PAW
            P := Numput(PixelArray[R, A_Index], P + 0, "UInt") - 1
        P += (PAW & 1)
    }
    HBM := DllCall("Gdi32.dll\CreateBitmap", "Int", PAW, "Int", PAH, "UInt", 1, "UInt", 24, "Ptr", 0, "UPtr")
    HBM := DllCall("User32.dll\CopyImage", "Ptr", HBM, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x2008, "UPtr")
    DllCall( "Gdi32.dll\SetBitmapBits", "Ptr", HBM, "UInt", SLL * PAH, "Ptr", &BMBITS)
    if (!Gradient)
        HBM := DllCall("User32.dll\CopyImage", "Ptr", HBM, "UInt", 0, "Int", 0, "Int", 0, "Int", 8, "UPtr")
    return DllCall("User32.dll\CopyImage", "Ptr", HBM, "UInt", 0, "Int", BMW, "Int", BMH, "UInt", 0x200C, "UPtr")
} ; http://ahkscript.org/boards/viewtopic.php?f=6&t=3203
