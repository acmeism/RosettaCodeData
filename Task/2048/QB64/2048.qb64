_DEFINE A-Z AS _INTEGER64
DIM SHARED Grid(0 TO 5, 0 TO 5) AS INTEGER
CONST Left = 19200
CONST Right = 19712
CONST Down = 20480
CONST Up = 18432
CONST ESC = 27
CONST LCtrl = 100306
CONST RCtrl = 100305

Init
MakeNewGame
DO
    _LIMIT 30
    ShowGrid
    CheckInput flag
    IF flag THEN GetNextNumber
    _DISPLAY
LOOP

SUB CheckInput (flag)
flag = 0
k = _KEYHIT
SELECT CASE k
    CASE ESC: SYSTEM
    CASE 83, 115 'S
        IF _KEYDOWN(LCtrl) OR _KEYDOWN(RCtrl) THEN MakeNewGame
    CASE Left
        MoveLeft
        flag = -1 'we hit a valid move key.  Even if we don't move, get a new number
    CASE Up
        MoveUp
        flag = -1
    CASE Down
        MoveDown
        flag = -1
    CASE Right
        MoveRight
        flag = -1
END SELECT
END SUB

SUB MoveDown
'first move everything left to cover the blank spaces
DO
    moved = 0
    FOR y = 4 TO 1 STEP -1
        FOR x = 1 TO 4
            IF Grid(x, y) = 0 THEN 'every point above this moves down
                FOR j = y TO 1 STEP -1
                    Grid(x, j) = Grid(x, j - 1)
                    IF Grid(x, j) <> 0 THEN moved = -1
                NEXT
            END IF
        NEXT
    NEXT
    IF moved THEN y = y + 1 'recheck the same column
LOOP UNTIL NOT moved
FOR y = 4 TO 1 STEP -1
    FOR x = 1 TO 4
        IF Grid(x, y) <> 0 AND Grid(x, y) = Grid(x, y - 1) THEN 'add them together and every point above this moves
            Grid(x, y) = Grid(x, y) * 2
            FOR j = y - 1 TO 1
                Grid(x, j) = Grid(x, j - 1)
            NEXT
        END IF
    NEXT
NEXT
END SUB

SUB MoveLeft
'first move everything to cover the blank spaces
DO
    moved = 0
    FOR x = 1 TO 4
        FOR y = 1 TO 4
            IF Grid(x, y) = 0 THEN 'every point right of this moves left
                FOR j = x TO 4
                    Grid(j, y) = Grid(j + 1, y)
                    IF Grid(j, y) <> 0 THEN moved = -1
                NEXT
            END IF
        NEXT
    NEXT
    IF moved THEN x = x - 1 'recheck the same row
LOOP UNTIL NOT moved
FOR x = 1 TO 4
    FOR y = 1 TO 4
        IF Grid(x, y) <> 0 AND Grid(x, y) = Grid(x + 1, y) THEN 'add them together and every point right of this moves left
            Grid(x, y) = Grid(x, y) * 2
            FOR j = x + 1 TO 4
                Grid(j, y) = Grid(j + 1, y)
            NEXT
        END IF
    NEXT
NEXT
END SUB

SUB MoveUp
'first move everything to cover the blank spaces
DO
    moved = 0
    FOR y = 1 TO 4
        FOR x = 1 TO 4
            IF Grid(x, y) = 0 THEN 'every point below of this moves up
                FOR j = y TO 4
                    Grid(x, j) = Grid(x, j + 1)
                    IF Grid(x, j) <> 0 THEN moved = -1
                NEXT
            END IF
        NEXT
    NEXT
    IF moved THEN y = y - 1 'recheck the same column
LOOP UNTIL NOT moved
FOR y = 1 TO 4
    FOR x = 1 TO 4
        IF Grid(x, y) <> 0 AND Grid(x, y) = Grid(x, y + 1) THEN 'add them together and every point below this moves
            Grid(x, y) = Grid(x, y) * 2
            FOR j = y + 1 TO 4
                Grid(x, j) = Grid(x, j + 1)
            NEXT
            Grid(x, 4) = 0
        END IF
    NEXT
NEXT
END SUB

SUB MoveRight
'first move everything to cover the blank spaces
DO
    moved = 0
    FOR x = 4 TO 1 STEP -1
        FOR y = 1 TO 4
            IF Grid(x, y) = 0 THEN 'every point right of this moves left
                FOR j = x TO 1 STEP -1
                    Grid(j, y) = Grid(j - 1, y)
                    IF Grid(j, y) <> 0 THEN moved = -1
                NEXT
            END IF
        NEXT
    NEXT
    IF moved THEN x = x - 1 'recheck the same row
LOOP UNTIL NOT moved

FOR x = 4 TO 1 STEP -1
    FOR y = 1 TO 4
        IF Grid(x, y) <> 0 AND Grid(x, y) = Grid(x - 1, y) THEN 'add them together and every point right of this moves left
            Grid(x, y) = Grid(x, y) * 2
            FOR j = x - 1 TO 1 STEP -1
                Grid(j, y) = Grid(j - 1, y)
            NEXT
        END IF
    NEXT
NEXT
END SUB

SUB ShowGrid
'SUB MakeBox (Mode AS INTEGER, x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER,
'Caption AS STRING, FontColor AS _UNSIGNED LONG, FontBackground AS _UNSIGNED LONG,
'BoxColor AS _UNSIGNED LONG, BoxHighLight AS _UNSIGNED LONG, XOffset AS INTEGER, YOffset AS INTEGER)
w = 120
h = 120
FOR x = 1 TO 4
    FOR y = 1 TO 4
        t$ = LTRIM$(STR$(Grid(x, y)))
        IF t$ = "0" THEN t$ = ""
        MakeBox 4, (x - 1) * w, (y - 1) * h, w, h, t$, -1, 0, 0, -1, 0, 0
    NEXT
NEXT
END SUB

SUB Init
ws = _NEWIMAGE(480, 480, 32)
SCREEN ws
_DELAY 1
_TITLE "Double Up"
_SCREENMOVE _MIDDLE
RANDOMIZE TIMER
f& = _LOADFONT("C:\Windows\Fonts\courbd.ttf", 32, "MONOSPACE")
_FONT f&

END SUB

SUB MakeNewGame
FOR x = 1 TO 4
    FOR y = 1 TO 4
        Grid(x, y) = 0
    NEXT
NEXT
GetNextNumber
GetNextNumber
END SUB

SUB GetNextNumber
FOR x = 1 TO 4
    FOR y = 1 TO 4
        IF Grid(x, y) = 0 THEN valid = -1
    NEXT
NEXT
IF valid THEN 'If all the grids are full, we can't add any more numbers
    'This doesn't mean the game is over, as the player may be able to
    DO
        x = _CEIL(RND * 4)
        y = _CEIL(RND * 4)
    LOOP UNTIL Grid(x, y) = 0
    Grid(x, y) = 2
END IF
END SUB

SUB MakeBox (Mode AS INTEGER, x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER, Caption AS STRING, FontColor AS _UNSIGNED LONG, FontBackground AS _UNSIGNED LONG, BoxColor AS _UNSIGNED LONG, BoxHighLight AS _UNSIGNED LONG, XOffset AS INTEGER, YOffset AS INTEGER)

'This is an upgrade version of my original Button routine.
'It's more versitile (but complex) than the original.
'Mode 0 (or any unsupported number) will tell the box to size itself from X1,Y1 to X2,Y2
'Mode 1 will tell the box to autosize itself according to whatever text is placed within it.
'Mode 2 will tell the box to use X2 and Y2 as relative coordinates and not absolute coordinates.
'Mode 3 will tell the box to autocenter text with X2, Y2 being absolute coordinates.
'Mode 4 will tell the box to autocenter text with X2, Y2 being relative coordinates.
'Mode otherwise is unused, but available for expanded functionality.
'X1 carries the X location of where we want to place our box on the screen.
'Y2 carries the Y location of where we want to place our box on the screen.
'X2 is the X boundry of our box on the screen, depending on our mode.
'Y2 is the Y boundry of our box on the screen, depending on our mode.

'Caption is the text that we want our box to contain.

'FontColor is our font color for our caption
'FontBackground is the font background color for our caption
'NOTE: IF FONTCOLOR OR FONTBACKGROUND IS SET TO ZERO, THEY WILL **NOT** AFFECT THE COLOR BEHIND THEM.
'This can be used to mimic the function of _KEEPBACKGROUND, _FILLBACKGROUND, or _ONLYBACKGROUND

'BoxColor is our box color
'BoxHighlight is our box highligh colors
'NOTE: SAME WITH BOXCOLOR AND BOXHIGHLIGHT.  IF SET TO ZERO, THEY WILL HAVE **NO** COLOR AT ALL TO THEM, AND WILL NOT AFFECT THE BACKGROUND OF ANYTHING BEHIND THEM.

'XOffset is used to offset our text # pixels from the X1 top.
'YOffset is used to offset our text # pixels from the Y1 top.
'These can be used to place our text wherever we want on our box.
'But remember, if Mode = 3 or 4, the box will autocenter the text and ignore these parameters completely.

DIM BoxBlack AS _UNSIGNED LONG

dc& = _DEFAULTCOLOR: bg& = _BACKGROUNDCOLOR
IF Black <> 0 THEN
    'We have black either as a CONST or a SHARED color
    BoxBlack = Black
ELSE
    'We need to define what Black is for our box.
    BoxBlack = _RGB32(0, 0, 0)
END IF

IF _FONTWIDTH <> 0 THEN cw = _FONTWIDTH * LEN(Caption) ELSE cw = _PRINTWIDTH(Caption)
ch = _FONTHEIGHT

tx1 = x1: tx2 = x2: ty1 = y1: ty2 = y2
SELECT CASE Mode
    CASE 0
        'We use the X2, Y2 coordinates provided as absolute coordinates
    CASE 1
        tx2 = tx1 + cw + 8
        ty2 = ty1 + ch + 8
        XOffset = 5: YOffset = 5
    CASE 2
        tx2 = tx1 + x2
        ty2 = ty1 + y2
    CASE 3
        XOffset = (tx2 - tx1 - cw) \ 2
        YOffset = (ty2 - ty1 - ch) \ 2
    CASE 4
        tx2 = tx1 + x2
        ty2 = ty1 + y2
        XOffset = (tx2 - tx1) \ 2 - cw \ 2
        YOffset = (ty2 - ty1 - ch) \ 2
END SELECT
LINE (tx1, ty1)-(tx2, ty2), BoxBlack, BF
LINE (tx1 + 1, ty1 + 1)-(tx2 - 1, ty2 - 1), BoxHighLight, B
LINE (tx1 + 2, ty1 + 2)-(tx2 - 2, ty2 - 2), BoxHighLight, B
LINE (tx1 + 3, ty1 + 3)-(tx2 - 3, ty2 - 3), BoxBlack, B
LINE (tx1, ty1)-(tx1 + 3, ty1 + 3), BoxBlack
LINE (tx2, ty1)-(tx2 - 3, ty1 + 3), BoxBlack
LINE (tx1, ty2)-(tx1 + 3, ty2 - 3), BoxBlack
LINE (tx2, ty2)-(tx2 - 3, ty2 - 3), BoxBlack
LINE (tx1 + 3, y1 + 3)-(tx2 - 3, ty2 - 3), BoxColor, BF
COLOR FontColor, FontBackground
_PRINTSTRING (tx1 + XOffset, ty1 + YOffset), Caption$
COLOR dc&, bg&
END SUB
