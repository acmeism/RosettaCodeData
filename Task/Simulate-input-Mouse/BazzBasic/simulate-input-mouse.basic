' ============================================
' Simulate input/Mouse — BazzBasic
' Three colored circles are drawn on screen.
' Click any mouse button over a circle to see
' which circle and which button were pressed.
' ============================================
' https://rosettacode.org/wiki/Simulate_input/Mouse
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

' --- Constants ---
LET SCREEN_W# = 640
LET SCREEN_H# = 480
LET RADIUS#   = 60
LET CY#       = 220         ' All circles share the same Y center
LET C1X#      = 130         ' Red circle X
LET C2X#      = 320         ' Green circle X
LET C3X#      = 510         ' Blue circle X

' --- Functions ---

' Returns 1 if point (mx$, my$) is inside the circle at (cx$, CY#)
DEF FN HitTest$(mx$, my$, cx$)
    IF DISTANCE(mx$, my$, cx$, CY#) <= RADIUS# THEN RETURN 1
    RETURN 0
END DEF

' --- Init ---
[inits]
    SCREEN 0, SCREEN_W#, SCREEN_H#, "Simulate Input / Mouse — BazzBasic"

    LET cRed$    = RGB(220, 60, 60)
    LET cGreen$  = RGB(50, 190, 80)
    LET cBlue$   = RGB(60, 110, 230)
    LET cWhite$  = RGB(255, 255, 255)
    LET cDark$   = RGB(18, 18, 28)

    LET prevL$   = 0
    LET prevR$   = 0
    LET prevM$   = 0

    LET msg$     = "Click any mouse button over a circle."
    LET msgCol$  = 7
    LET msgLen$  = 0
    LET msgStart$ = 1
    LET running$ = TRUE

    LET mx$      = 0
    LET my$      = 0
    LET ml$      = 0
    LET mr$      = 0
    LET mm$      = 0
    LET newL$    = 0
    LET newR$    = 0
    LET newM$    = 0
    LET clicked$ = 0
    LET btn$     = ""

    ' Draw the static scene once before entering the loop
    GOSUB [sub:draw]

' --- Main loop ---
[main]
    WHILE running$
        IF INKEY = KEY_ESC# THEN running$ = FALSE

        mx$ = MOUSEX
        my$ = MOUSEY
        ml$ = MOUSELEFT
        mr$ = MOUSERIGHT
        mm$ = MOUSEMIDDLE

        ' Detect a fresh press (0 → 1 transition) on any button
        newL$ = (ml$ = 1 AND prevL$ = 0)
        newR$ = (mr$ = 1 AND prevR$ = 0)
        newM$ = (mm$ = 1 AND prevM$ = 0)

        clicked$ = 0
        IF newL$ THEN clicked$ = 1
        IF newR$ THEN clicked$ = 1
        IF newM$ THEN clicked$ = 1

        IF clicked$ THEN
            ' Identify which button was pressed
            btn$ = ""
            IF newL$ THEN btn$ = "LEFT"
            IF newR$ THEN btn$ = "RIGHT"
            IF newM$ THEN btn$ = "MIDDLE"

            ' Identify which circle was hit (if any)
            IF FN HitTest$(mx$, my$, C1X#) THEN
                msg$    = btn$ + " button — RED circle"
                msgCol$ = 12
            ELSEIF FN HitTest$(mx$, my$, C2X#) THEN
                msg$    = btn$ + " button — GREEN circle"
                msgCol$ = 10
            ELSEIF FN HitTest$(mx$, my$, C3X#) THEN
                msg$    = btn$ + " button — BLUE circle"
                msgCol$ = 9
            ELSE
                msg$    = btn$ + " button — outside all circles"
                msgCol$ = 7
            END IF

            ' Only redraw when something actually changed
            GOSUB [sub:draw]
        END IF

        prevL$ = ml$
        prevR$ = mr$
        prevM$ = mm$

        SLEEP 16
    WEND
END

' --- Draw subroutine ---
[sub:draw]
    SCREENLOCK ON

    ' Clear screen with dark background
    LINE (0,0)-(SCREEN_W#, SCREEN_H#), cDark$, BF

    ' Title
    LOCATE 2, 23
    COLOR 14, 0
    PRINT "Simulate Input / Mouse"

    ' Three filled circles with white outlines
    CIRCLE (C1X#, CY#), RADIUS#,      cRed$,   1
    CIRCLE (C1X#, CY#), RADIUS# + 1,  cWhite$

    CIRCLE (C2X#, CY#), RADIUS#,      cGreen$, 1
    CIRCLE (C2X#, CY#), RADIUS# + 1,  cWhite$

    CIRCLE (C3X#, CY#), RADIUS#,      cBlue$,  1
    CIRCLE (C3X#, CY#), RADIUS# + 1,  cWhite$

    ' Labels below each circle
    LOCATE 27, 15
    COLOR 12, 0
    PRINT "RED"

    LOCATE 27, 39
    COLOR 10, 0
    PRINT "GREEN"

    LOCATE 27, 63
    COLOR 9, 0
    PRINT "BLUE"

    ' Status message — centered on row 34
    msgLen$   = LEN(msg$)
    msgStart$ = CINT((80 - msgLen$) / 2)
    LOCATE 44, msgStart$
    COLOR msgCol$, 0
    PRINT msg$

    ' ESC hint at bottom
    LOCATE 51, 28
    COLOR 7, 0
    PRINT "Press ESC to quit"

    SCREENLOCK OFF
RETURN
