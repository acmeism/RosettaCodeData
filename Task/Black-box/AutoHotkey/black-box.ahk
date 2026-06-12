SetBatchLines -1
;--------------------------------------------------------------------------------------
BoardSize := 8
GUI()
setupBoard()
OnMessage(0x0201, "WM_LBUTTONDOWN")
return
;--------------------------------------------------------------------------------------
GUI(){
    global
    BoardSize += 2                ; add left/right and top/buttom
    lastIndex := BoardSize-1    ; 0-based
    symbol := {}, w := h := 30
    Menu, FileMenu, Add, Manual Entry, MenuHandler
    Menu, FileMenu, Add, E&xit, MenuHandler
    Menu, MyMenuBar, Add, &File, :FileMenu
    Gui, Menu, MyMenuBar
    Gui, font, s14, Consolas
    loop % BoardSize**2
    {
        r := (A_Index-1)//BoardSize, c := Mod(A_Index-1, BoardSize)
        options := r = 0            ?    " v" r "_" c " gSendRay"
                :  c = 0            ?    " v" r "_" c " gSendRay"
                :  c = lastIndex    ?    " v" r "_" c " gSendRay"
                :  r = lastIndex    ?    " v" r "_" c " gSendRay"
                :                        " v" r "_" c

        if (c = 0 && r = 0)
            Gui, add, button, % "section x14 y14 w" w " h" h options
        else if c = 0
            Gui, add, button, % "section x14 y+0 w" w " h" h options
        else
            Gui, add, button, % "x+0 w" w " h" h options
    }
    for i, v in StrSplit("0_0,0_" lastIndex "," lastIndex "_0," lastIndex "_" lastIndex "", ",")
        GuiControl, hide, % v
    Gui, font, s10, Consolas
    Gui, add, button, xs w80 vButtonDone gDone Disabled, % ButtonDoneText := "Done"
    Gui, add, text, x+10, % "?? = Hit, ? = Reflection"
    Gui, add, text, y+5 , % "Atoms Found = "
    Gui, add, text, x+0 vTextAtom w80
    Gui, +AlwaysOnTop
    Gui, show,, Black Box
}
;--------------------------------------------------------------------------------------
GuiClose:
ExitApp
return
;--------------------------------------------------------------------------------------
MenuHandler(){
    global
    if (A_ThisMenuItem = "Manual Entry")
    {
        Menu, FileMenu, ToggleCheck, Manual Entry
        if (Manual_Entry := !Manual_Entry)
            resetBoard()
        else
            Board := [], mapBoard()
    }
    if (A_ThisMenuItem = "E&xit")
        ExitApp
}
;--------------------------------------------------------------------------------------
setupBoard(){    ; land mines in random spots on PlayField
    global
    resetBoard()
    if Manual_Entry
        return

    Random, atoms, % Floor(BoardSize/2)-1, % Floor(BoardSize/2)
    ;~ atoms += 8
    loop % atoms
    {
        Random, rnd, 1, PlayField.Count()
        x := PlayField.RemoveAt(rnd)
        Mines[x.1, x.2] := true
    }
    mapBoard()
}
;--------------------------------------------------------------------------------------
resetBoard(){    ; Reset All
    global
    Board:=[], PlayField:=[], Mines:=[], Solution:=[], symbol:=[], found:=atoms:=0
    loop % BoardSize*4
        symbol.Push(Chr(0x0387+A_Index))
    loop % BoardSize**2
    {
        r := (A_Index-1)//BoardSize, c := Mod(A_Index-1, BoardSize)
        if (r>0 && r<lastIndex && c>0 && c<lastIndex)
            PlayField.Push([r , c])
    }
    mapBoard()
}
;--------------------------------------------------------------------------------------
mapBoard(){        ; map all buttons to reflect Board
    global
    loop % BoardSize**2
    {
        r := (A_Index-1)//BoardSize, c := Mod(A_Index-1, BoardSize)
        GuiControl,, % r "_" c, % ""
        GuiControl,, % r "_" c, % v := Board[r, c]
        if (r>0 && r<lastIndex && c>0 && c<lastIndex)
            GuiControl, % (v = "" || v = "?" || v = "+") ? "Disable" : "Enable", % r "_" c
    }
    GuiControl,, ButtonDone, % ButtonDoneText
    GuiControl,, TextAtom, % found " / " atoms
    GuiControl, % found = atoms ? "Enable" : "Disable", ButtonDone
}
;--------------------------------------------------------------------------------------
WM_LBUTTONDOWN(){
    global
    MouseGetPos, mx, my, mw, buttonNum
    buttonNum := StrReplace(buttonNum, "Button") - 1
    r := buttonNum//BoardSize, c := Mod(buttonNum, BoardSize)
    if !(R>0 && r<lastIndex && c>0 && c<lastIndex)
        return

    if Manual_Entry
    {
        Mines[r, c] := !Mines[r, c]
        Board[r, c] := Mines[r, c] ? "?" : ""
        atoms := Mines[r, c] ? atoms+1 : atoms-1
    }
    else
    {
        Solution[r, c] := !Solution[r, c]
        Board[r, c] := Solution[r, c] ? "??" : ""
        found := Board[r, c] ? found + 1 : found -1
    }
    mapBoard()
}
;--------------------------------------------------------------------------------------
Done(){
    global
    if (ButtonDoneText = "done")
    {
        ButtonDoneText := ":)"
        for r, obj in Solution
            for c, bool in obj
                if Solution[r, c] && (Mines[r, c] = Solution[r, c])
                    Board[r, c] := "?"    ; right
                else if Solution[r, c] && (Mines[r, c] <> Solution[r, c])
                    Board[r, c] := "?"    , ButtonDoneText := ":(" ; wrong marking
        for r, obj in Mines
            for c, bool in obj
                if Mines[r, c] && (Mines[r, c] <> Solution[r, c])
                    Board[r, c] := "?"    , ButtonDoneText := ":(" ; missed marking
        mapBoard()
    }
    else
    {
        ButtonDoneText := "Done"
        setupBoard()
    }
}
;--------------------------------------------------------------------------------------
SendRay(){
    global

    ; troubleshooting
    if TroubleShooting
    {
        loop % BoardSize**2
            r := (A_Index-1)//BoardSize, c := Mod(A_Index-1, BoardSize)
            , Board[r, c] := Board[r, c] = "+" ? "" : Board[r, c]
        mapBoard()
    }

    x := StrSplit(A_GuiControl, "_")
    r := x.1, c := x.2
    dir := (r = 0) ? "D" : (r = lastIndex) ? "U" : (c = 0) ? "R" : (c = lastIndex) ? "L" : ""
    t := Board[r, c]
    if (t && t<>"??" && t<>"?")
        symbol.Push(t)

    BlackBox([r, c, dir])
    mapBoard()
}
;--------------------------------------------------------------------------------------
BlackBox(Coord){
    global
    end := Ray(Coord)
    r := Coord.1, c := Coord.2
    endR := end.1, endC := end.2
    if (end.3 = "hit")
        Board[r, c] := "??"        ; Hit
    else if (r = endR && c = endC)
        Board[r, c] := "?"        ; Reflection
    else if (end.3 = "miss")
    {
        Random, rnd, 1, % symbol.Count()
        ch := symbol.RemoveAt(rnd)
        Board[r, c] := ch
        Board[endR, endC] := ch    ; Miss
    }
}
;--------------------------------------------------------------------------------------
Ray(Coord){
    global
    r := Coord.1, c := Coord.2, dir := Coord.3
    deltaR := dir = "D" ? 1 : dir = "U" ? -1 : 0
    deltaC := dir = "R" ? 1 : dir = "L" ? -1 : 0

    if TroubleShooting
    {
        Board[r, c] := "+"
        GuiControl,, % r "_" c, % "+"
        Sleep 5
    }

    ; Hit
    if (dir = "R" && Mines[r, c+1])
        return [r, c, "hit"]
    if (dir = "L" && Mines[r, c-1])
        return [r, c, "hit"]
    if (dir = "U" && Mines[r-1, c])
        return [r, c, "hit"]
    if (dir = "D" && Mines[r+1, c])
        return [r, c, "hit"]

    ; Deflection
    if (dir = "R" && Mines[r+1, c+1])
        return c=0 ? [r, c, "deflect"] : Ray([r, c, "U"])            ; right to up
    if (dir = "R" && Mines[r-1, c+1])
        return c=0 ? [r, c, "deflect"] : Ray([r, c, "D"])            ; right to down
    if (dir = "L" && Mines[r+1, c-1])
        return c=lastIndex ? [r, c, "deflect"] : Ray([r, c, "U"])    ; left to up
    if (dir = "L" && Mines[r-1, c-1])
        return c=lastIndex ? [r, c, "deflect"] : Ray([r, c, "D"])    ; left to down
    if (dir = "U" && Mines[r-1, c+1])
        return r=lastIndex ? [r, c, "deflect"] : Ray([r, c, "L"])    ; up to left
    if (dir = "U" && Mines[r-1, c-1])
        return r=lastIndex ? [r, c, "deflect"] : Ray([r, c, "R"])    ; up to down
    if (dir = "D" && Mines[r+1, c+1])
        return r=0 ? [r, c, "deflect"] : Ray([r, c, "L"])            ; down to left
    if (dir = "D" && Mines[r+1, c-1])
        return r=0 ? [r, c, "deflect"] : Ray([r, c, "R"])            ; down to right

    r += deltaR, c += deltaC                                        ; advance
    ; Miss
    if (r=0 || r=lastIndex || c=0 || c=lastIndex)
        return [r, c, "miss"]
    return Ray([r, c, dir])
}
;--------------------------------------------------------------------------------------
Alt::    ; for troubleshooting purposes only ;-)
TroubleShooting := !TroubleShooting
Gui, show,, % TroubleShooting ? "Black Box - TroubleShooting Mode" : "Black Box"
return
;--------------------------------------------------------------------------------------
