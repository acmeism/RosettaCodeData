;---------------------------------------------------------------------------
; Pascal's triangle.ahk
; by wolf_II
;---------------------------------------------------------------------------
; http://rosettacode.org/wiki/Pascal's_triangle/Puzzle
;---------------------------------------------------------------------------



;---------------------------------------------------------------------------
AutoExecute: ; auto-execute section of the script
;---------------------------------------------------------------------------
    #SingleInstance, Force          ; only one instance allowed
    #NoEnv                          ; don't check empty variables
    ;-----------------------------------------------------------------------
    AppName := "Pascal's triangle"
    N1 := 11, N2 := 4, N3 := 40, N4 := 151

    ; monitor MouseMove events
    OnMessage(0x0200, "WM_MOUSEMOVE")

    ; GUI
    Gosub, GuiCreate
    Gui, Show,, %AppName%

Return



;---------------------------------------------------------------------------
GuiCreate: ; create the GUI
;---------------------------------------------------------------------------
    Gui, -MinimizeBox
    Gui, Margin, 8, 8

    ; 15 edit controls
    Loop, 5
        Loop, % Row := A_Index {
            xx := 208 + (A_Index - 5) * 50 - (Row - 5) * 25
            yy := 8 + (Row - 1) * 22
            vv := Row "_" A_Index
            Gui, Add, Edit, x%xx% y%yy% w50 v%vv% Center ReadOnly -TabStop
        }
    GuiControl, -WantReturn, Edit11
    GuiControl, -WantReturn, Edit15

    ; buttons (2 hidden)
    Gui, Add, Button, x8 w78, &Restart
    Gui, Add, Button, x+8 wp, &Solve
    Gui, Add, Button, x+8 wp, &Check
    Gui, Add, Button, x8 wp, Cle&ar
    Gui, Add, Button, xp wp Hidden, &Cancel
    Gui, Add, Button, x+8 wp, &New
    Gui, Add, Button, xp wp Hidden, &Apply
    Gui, Add, Button, x+8 wp, E&xit

    ; status bar
    Gui, Add, StatusBar

    ; blue font
    Gui, Font, bold cBlue
    GuiControl, Font, Edit11
    GuiControl, Font, Edit15
    ; falling through

;---------------------------------------------------------------------------
ButtonRestart: ; restart retaining the blue clues
;---------------------------------------------------------------------------
    Controls(True) ; enable controls
    Loop, 15
        If A_Index Not In 1,4,11,12,14,15
            GuiControl,, Edit%A_Index% ; clear
    GuiControl,, Edit1, %N4%
    GuiControl,, Edit4, %N3%
    GuiControl,, Edit12, %N1%
    GuiControl,, Edit14, %N2%
    GuiControl,, Edit11, %X%
    GuiControl,, Edit15, %Z%
    GreenFont:
    Gui, Font, bold cGreen
    GuiControl, Font, Edit1
    GuiControl, Font, Edit4
    GuiControl, Font, Edit12
    GuiControl, Font, Edit14

Return



;---------------------------------------------------------------------------
ButtonSolve: ; calculate solution
;---------------------------------------------------------------------------
    ; N1 := 11    N2 := 4    N3 := 40    N4 := 151
    ;-----------------------------------------------------------------------
    ; Y = X + Z
    ; 40  = (11+X) + (11+Y)
    ; A   = (11+Y) + (Y+4)
    ; B   =  (4+Y) + (4+Z)
    ; 151 = (40+A) + (A+B)
    ;-----------------------------------------------------------------------
    Gosub, GreenFont
    GuiControl,, Edit15, % Z := Round( (2*N4 - 7*N3 - 8*N2 + 6*N1) / 7 )
    GuiControl,, Edit11, % X := Round( (N3 - 2*N1 - Z) / 2 )
    ; falling through

;---------------------------------------------------------------------------
ButtonCheck: ; check the [entry|solution] for errors
;---------------------------------------------------------------------------
    Controls(False) ; disable controls
    Gui, Submit, NoHide
    X := 5_1, Z := 5_5
    Loop, 5
        Loop, % Row := A_Index
            If (%Row%_%A_Index% = "")
                %Row%_%A_Index% := 0
    GuiControl,, Edit13, % 5_3 := 5_1 + 5_5
    GuiControl,, Edit10, % 4_4 := 5_4 + 5_5
    GuiControl,, Edit9,  % 4_3 := 5_3 + 5_4
    GuiControl,, Edit8,  % 4_2 := 5_2 + 5_3
    GuiControl,, Edit7,  % 4_1 := 5_1 + 5_2
    GuiControl,, Edit6,  % 3_3 := 4_4 + 4_3
    GuiControl,, Edit5,  % 3_2 := 4_3 + 4_2
    GuiControl,, Edit4,  % 3_1 := 4_2 + 4_1
    GuiControl,, Edit3,  % 2_2 := 3_3 + 3_2
    GuiControl,, Edit2,  % 2_1 := 3_2 + 3_1
    GuiControl,, Edit1,  % 1_1 := 2_2 + 2_1
    Gui, Font, bold cRed
    If Not 3_1 = N3
        GuiControl, Font, Edit4
    If Not 1_1 = N4
        GuiControl, Font, Edit1

Return



;---------------------------------------------------------------------------
ButtonClear: ; restart without the blue clues
;---------------------------------------------------------------------------
    X := Z := ""
    Gosub, ButtonRestart

Return



;---------------------------------------------------------------------------
ButtonNew: ; enter new numbers for the puzzle
;---------------------------------------------------------------------------
    Gosub, GreenFont
    Loop, 15
        If A_Index Not In 1,4,12,14
            GuiControl,, Edit%A_Index% ; clear
    Controls(False) ; disable controls
    NewContr(True)  ; enable controls for new numbers

Return



;---------------------------------------------------------------------------
ButtonApply: ; remember the new numbers
;---------------------------------------------------------------------------
    Gui, Submit, NoHide
    N1 := 5_2, N2 := 5_4, N3 := 3_1, N4 := 1_1
    NewContr(False) ; disable controls for new numbers
    Controls(True)  ; enable controls

Return



;---------------------------------------------------------------------------
ButtonCancel: ; restore the old numbers
;---------------------------------------------------------------------------
    GuiControl,, Edit1, %N4%
    GuiControl,, Edit4, %N3%
    GuiControl,, Edit12, %N1%
    GuiControl,, Edit14, %N2%
    NewContr(False) ; disable controls for new numbers
    Controls(True)  ; enable controls

Return



;---------------------------------------------------------------------------
GuiClose:
;---------------------------------------------------------------------------
GuiEscape:
;---------------------------------------------------------------------------
ButtonExit:
;---------------------------------------------------------------------------
    ; common action
    ExitApp

Return



;---------------------------------------------------------------------------
Controls(Bool) { ; [dis|re-en]able some controls
;---------------------------------------------------------------------------
    Enable  := Bool ? "+" : "-"
    Disable := Bool ? "-" : "+"

    GuiControl, %Disable%ReadOnly, Edit11
    GuiControl, %Disable%ReadOnly, Edit15
    GuiControl, %Enable%TabStop, Edit11
    GuiControl, %Enable%TabStop, Edit15

    GuiControl, %Disable%Default, &Restart
    GuiControl, %Enable%Default, &Check
    GuiControl, %Disable%Disabled, &Check
    GuiControl, %Enable%Disabled, &Restart
}



;---------------------------------------------------------------------------
NewContr(Bool) { ; [dis|re-en]able control for new numbers
;---------------------------------------------------------------------------
    Enable  := Bool ? "+" : "-"
    Disable := Bool ? "-" : "+"

    GuiControl, %Disable%ReadOnly, Edit1
    GuiControl, %Disable%ReadOnly, Edit4
    GuiControl, %Disable%ReadOnly, Edit12
    GuiControl, %Disable%ReadOnly, Edit14

    GuiControl, %Enable%TabStop, Edit1
    GuiControl, %Enable%TabStop, Edit4
    GuiControl, %Enable%TabStop, Edit12
    GuiControl, %Enable%TabStop, Edit14

    GuiControl, %Enable%Hidden, Button1
    GuiControl, %Enable%Hidden, Button2
    GuiControl, %Enable%Hidden, Button3
    GuiControl, %Enable%Hidden, Button4
    GuiControl, %Disable%Hidden, Button5
    GuiControl, %Enable%Hidden, Button6
    GuiControl, %Disable%Hidden, Button7
    GuiControl, %Enable%Hidden, Button8

}



;---------------------------------------------------------------------------
WM_MOUSEMOVE() { ; monitor MouseMove events
;---------------------------------------------------------------------------
    ; display quick help in StatusBar
    ;-----------------------------------------------------------------------
    global AppName
    CurrControl := A_GuiControl
    IfEqual True,, MsgBox ; dummy

    ; mouse is over buttons
    Else If (CurrControl = "&Restart")
        SB_SetText("restart retaining the blue clues")
    Else If (CurrControl = "&Solve")
        SB_SetText("calculate solution")
    Else If (CurrControl = "&Check")
        SB_SetText("check if the entries are correct")
    Else If (CurrControl = "Cle&ar")
        SB_SetText("restart without the blue clues")
    Else If (CurrControl = "&New")
        SB_SetText("enter new numbers for the puzzle")
    Else If (CurrControl = "E&xit")
        SB_SetText("exit " AppName)

    ; delete status bar text
    Else SB_SetText("")
}
