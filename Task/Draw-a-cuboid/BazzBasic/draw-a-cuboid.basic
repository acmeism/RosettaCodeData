' ============================================
' https://rosettacode.org/wiki/Draw_a_cuboid
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

[inits]
    LET SCREEN_W# = 640
    LET SCREEN_H# = 480
    SCREEN 0, SCREEN_W#, SCREEN_H#, "Draw a cuboid"

    ' Relative dimensions 2 : 3 : 4
    LET W# = 100                ' width  (2 units)
    LET H# = 150                ' height (3 units)
    LET D# = 200                ' depth  (4 units)

    ' Cabinet projection: depth halved, drawn at 30 degrees
    LET ANGLE# = 30
    LET DX# = (D# / 2) * COS(RAD(ANGLE#))
    LET DY# = (D# / 2) * SIN(RAD(ANGLE#))

    ' Top-left corner of the front face on screen
    LET FX# = 200
    LET FY# = 200

    ' Palette
    LET BG#        = RGB( 30,  30,  40)
    LET OUTLINE#   = RGB(255, 255, 255)
    LET COL_FRONT# = RGB(120, 160, 210)
    LET COL_TOP#   = RGB(190, 220, 240)
    LET COL_RIGHT# = RGB( 70, 100, 150)

    LET keyPressed$ = 0

[main]
    SCREENLOCK ON
        LINE (0, 0)-(SCREEN_W#, SCREEN_H#), BG#, BF

        GOSUB [sub:DrawEdges]

    ' Flood-fill the three visible faces from a point inside each one
        PAINT (FX# + W# / 2,           FY# + H# / 2),            COL_FRONT#, OUTLINE#
        PAINT (FX# + W# / 2 + DX# / 2, FY# - DY# / 2),           COL_TOP#,   OUTLINE#
        PAINT (FX# + W# + DX# / 2,     FY# + H# / 2 - DY# / 2),  COL_RIGHT#, OUTLINE#

        DRAWSTRING "Cuboid 2 x 3 x 4 (cabinet projection)", 175, 400, OUTLINE#
        DRAWSTRING "Press any key to exit",                 230, 430, OUTLINE#
    SCREENLOCK OFF

    LET keyPressed$ = WAITKEY()
END

' --------------------------------------------
' Subroutines
' --------------------------------------------

[sub:DrawEdges]
    ' Front face (rectangle)
    LINE (FX#,      FY#)      - (FX# + W#, FY#),       OUTLINE#
    LINE (FX# + W#, FY#)      - (FX# + W#, FY# + H#),  OUTLINE#
    LINE (FX# + W#, FY# + H#) - (FX#,      FY# + H#),  OUTLINE#
    LINE (FX#,      FY# + H#) - (FX#,      FY#),       OUTLINE#

    ' Top face (back edge + two depth edges from the front-top corners)
    LINE (FX#,           FY#)       - (FX# + DX#,      FY# - DY#),  OUTLINE#
    LINE (FX# + W#,      FY#)       - (FX# + W# + DX#, FY# - DY#),  OUTLINE#
    LINE (FX# + DX#,     FY# - DY#) - (FX# + W# + DX#, FY# - DY#),  OUTLINE#

    ' Right face (back-right vertical + bottom depth edge)
    LINE (FX# + W# + DX#, FY# - DY#) - (FX# + W# + DX#, FY# + H# - DY#),  OUTLINE#
    LINE (FX# + W#,       FY# + H#)  - (FX# + W# + DX#, FY# + H# - DY#),  OUTLINE#
RETURN

' Output:
' A 640 x 480 window with a 2 x 3 x 4 cuboid in cabinet projection.
' Front face is medium blue, the top face (lit from above) is the lightest,
' and the right side is the darkest. White outlines mark every visible edge.
' Press any key to close the window.
