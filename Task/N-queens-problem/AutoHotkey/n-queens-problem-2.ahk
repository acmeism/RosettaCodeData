N := 5
Number: ; main entrance for different # of queens
    SI := 1
    Progress b2 w250 zh0 fs9, Calculating all solutions for %N% Queens ...
    Gosub GuiCreate
    Result := SubStr(Queens(N),2)
    Progress Off
    Gui Show,,%N%-Queens
    StringSplit o, Result, `n
Fill: ; show solutions
    GuiControl,,SI, %SI% / %o0%
    Loop Parse, o%SI%, `,
    {
        C := A_Index
        Loop %N%
            GuiControl,,%C%_%A_Index% ; clear fields
        GuiControl,,%C%_%A_LoopField%, r
    }
Return ;-----------------------------------------------------------------------

Queens(N) {                                 ; Size of the board
    Local c, O                              ; global array r
    r1 := 1, c := 2, r2 := 3, O := ""       ; init: r%c% = row of Queen in column c

    Right:                                  ; move to next column
        If (c = N) {                        ; found solution
            Loop %N%                        ; save row indices of Queens
                O .= (A_Index = 1 ? "`n" : ",") r%A_Index%
            GOTO % --c ? "Down" : "OUT"     ; for ALL solutions
        }
        c++, r%c% := 1                      ; next column, top row
        GoTo % BAD(c) ? "Down" : "Right"
    Down:                                   ; move down to next row
        If (r%c% = N)
            GoTo % --c ? "Down" : "OUT"
        r%c%++                              ; row down
        GoTo % BAD(c) ? "Down" : "Right"
    OUT:
        Return O
} ;----------------------------------------------------------------------------

BAD(c) { ; Check placed Queens against Queen in row r%c%, column c
    Loop % c-1
        If (r%A_Index% = r%c% || ABS(r%A_Index%-r%c%) = c-A_Index)
            Return 1
} ;----------------------------------------------------------------------------

GuiCreate: ; Draw chess board
    Gui Margin, 20, 15
    Gui Font, s16, Marlett
    Loop %N% {
        C := A_Index
        Loop %N% { ; fields
            R := A_Index, X := 40*C-17, Y := 40*R-22
            Gui Add, Progress, x%X% y%Y% w41 h41 Cdddddd, % 100*(R+C & 1) ;% shade fields
            Gui Add, Text, x%X% y%Y% w41 h41 BackGroundTrans Border Center 0x200 v%C%_%R%
        }
    }
    Gui Add, Button, x%x% w43 h25 gBF, 4 ; forth (default)
    Gui Add, Button,xm yp w43 h25 gBF, 3 ; back

    Gui Font, bold, Comic Sans MS
    Gui Add, Text,% "x62 yp hp Center 0x200 vSI w" 40*N-80

    Menu FileMenu, Add, E&xit, GuiClose
    Loop 9
        Menu CalcMenu, Add, % "Calculate " A_Index+3 " Queens", Calculate ;%
    Menu HelpMenu, Add, &About, AboutBox
    Menu MainMenu, Add, &File, :FileMenu
    Menu MainMenu, Add, &Calculate, :CalcMenu
    Menu MainMenu, Add, &Help, :HelpMenu
    Gui Menu, Mainmenu
Return ; ----------------------------------------------------------------------

AboutBox: ; message box with AboutText
    Gui 1: +OwnDialogs
    MsgBox, 64, About N-Queens, Many thanks ...
Return

Calculate: ; menu handler for calculations
    N := A_ThisMenuItemPos + 3
    Gui Destroy
    GoTo Number ; -------------------------------------------------------------

BF:
   SI := mod(SI+o0-2*(A_GuiControl=3), o0) + 1 ; left button text is "3"
   GoTo Fill ; ----------------------------------------------------------------

GuiClose:
ExitApp
