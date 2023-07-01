SCREEN 13
PALETTE 1, pColor(35, 33, 31)
PALETTE 2, pColor(46, 46, 51)
PALETTE 3, pColor(59, 56, 50)
PALETTE 4, pColor(61, 44, 30)
PALETTE 5, pColor(61, 37, 25)
PALETTE 6, pColor(62, 31, 24)
PALETTE 7, pColor(62, 24, 15)
PALETTE 8, pColor(59, 52, 29)
PALETTE 9, pColor(59, 51, 24)
PALETTE 10, pColor(59, 50, 20)
PALETTE 11, pColor(59, 49, 16)
PALETTE 12, pColor(59, 49, 12)
PALETTE 13, pColor(15, 15, 13)
PALETTE 14, pColor(23, 22, 20)

DIM SHARED gDebug
DIM SHARED gOriginX
DIM SHARED gOriginY
DIM SHARED gTextOriginX
DIM SHARED gTextOriginY
DIM SHARED gSquareSide
DIM SHARED gGridSize

gGridSize = 4  ' grid size (4 -> 4x4)

DIM SHARED gGrid(gGridSize, gGridSize)
DIM SHARED gScore

' Don't touch these numbers, seriously

gOriginX = 75 'pixel X of top left of grid
gOriginY = 12 'pixel Y of top right of grid
gTextOriginX = 11
gTextOriginY = 3
gSquareSide = 38 'width/height of block in pixels


'set up all the things!
gDebug = 0

RANDOMIZE TIMER
CLS

start:
initGrid
initGraphicGrid
renderGrid
updateScore

gScore = 0

LOCATE 23, 1
PRINT "Move with arrow keys. (R)estart, (Q)uit"

' keyboard input loop
DO
  DO
    k$ = INKEY$
  LOOP UNTIL k$ <> ""

  SELECT CASE k$
    CASE CHR$(0) + CHR$(72) 'up
      processMove ("u")
    CASE CHR$(0) + CHR$(80) 'down
      processMove ("d")
    CASE CHR$(0) + CHR$(77) 'right
      processMove ("r")
    CASE CHR$(0) + CHR$(75) 'left
      processMove ("l")
    CASE CHR$(27)           'escape
      GOTO programEnd
    CASE "q"
      GOTO programEnd
    CASE "Q"
      GOTO programEnd
    CASE "r"
      GOTO start
    CASE "R"
      GOTO start
  END SELECT
LOOP

programEnd:

SUB addblock
  DIM emptyCells(gGridSize * gGridSize, 2)
  emptyCellCount = 0

  FOR x = 0 TO gGridSize - 1
    FOR y = 0 TO gGridSize - 1
      IF gGrid(x, y) = 0 THEN
        emptyCells(emptyCellCount, 0) = x
        emptyCells(emptyCellCount, 1) = y
        emptyCellCount = emptyCellCount + 1
      END IF
    NEXT y
  NEXT x

  IF emptyCellCount > 0 THEN
    index = INT(RND * emptyCellCount)
    num = CINT(RND + 1) * 2
    gGrid(emptyCells(index, 0), emptyCells(index, 1)) = num
  END IF

END SUB

SUB drawNumber (num, xPos, yPos)
  SELECT CASE num
    CASE 0:    c = 16
    CASE 2:    c = 2
    CASE 4:    c = 3
    CASE 8:    c = 4
    CASE 16:   c = 5
    CASE 32:   c = 6
    CASE 64:   c = 7
    CASE 128:  c = 8
    CASE 256:  c = 9
    CASE 512:  c = 10
    CASE 1024: c = 11
    CASE 2048: c = 12
    CASE 4096: c = 13
    CASE 8192: c = 13
    CASE ELSE: c = 13
  END SELECT

  x = xPos * (gSquareSide + 2) + gOriginX + 1
  y = yPos * (gSquareSide + 2) + gOriginY + 1
  LINE (x + 1, y + 1)-(x + gSquareSide - 1, y + gSquareSide - 1), c, BF

  IF num > 0 THEN
    LOCATE gTextOriginY + 1 + (yPos * 5), gTextOriginX + (xPos * 5)
    PRINT "    "
    LOCATE gTextOriginY + 2 + (yPos * 5), gTextOriginX + (xPos * 5)
    PRINT pad$(num)
    LOCATE gTextOriginY + 3 + (yPos * 5), gTextOriginX + (xPos * 5)
    'PRINT "    "
  END IF

END SUB

FUNCTION getAdjacentCell (x, y, d AS STRING)

  IF (d = "l" AND x = 0) OR (d = "r" AND x = gGridSize - 1) OR (d = "u" AND y = 0) OR (d = "d" AND y = gGridSize - 1) THEN
    getAdjacentCell = -1
  ELSE
    SELECT CASE d
      CASE "l": getAdjacentCell = gGrid(x - 1, y)
      CASE "r": getAdjacentCell = gGrid(x + 1, y)

      CASE "u": getAdjacentCell = gGrid(x, y - 1)
      CASE "d": getAdjacentCell = gGrid(x, y + 1)
    END SELECT
  END IF

END FUNCTION

'Draws the outside grid (doesn't render tiles)
SUB initGraphicGrid

  gridSide = (gSquareSide + 2) * gGridSize

  LINE (gOriginX, gOriginY)-(gOriginX + gridSide, gOriginY + gridSide), 14, BF 'outer square, 3 thick
  LINE (gOriginX, gOriginY)-(gOriginX + gridSide, gOriginY + gridSide), 1, B 'outer square, 3 thick
  LINE (gOriginX - 1, gOriginY - 1)-(gOriginX + gridSide + 1, gOriginY + gridSide + 1), 1, B
  LINE (gOriginX - 2, gOriginY - 2)-(gOriginX + gridSide + 2, gOriginY + gridSide + 2), 1, B

  FOR x = gOriginX + gSquareSide + 2 TO gOriginX + (gSquareSide + 2) * gGridSize STEP gSquareSide + 2  ' horizontal lines
    LINE (x, gOriginY)-(x, gOriginY + gridSide), 1
  NEXT x

  FOR y = gOriginY + gSquareSide + 2 TO gOriginY + (gSquareSide + 2) * gGridSize STEP gSquareSide + 2 ' vertical lines
    LINE (gOriginX, y)-(gOriginX + gridSide, y), 1
  NEXT y

END SUB

'Init the (data) grid with 0s
SUB initGrid
  FOR x = 0 TO 3
    FOR y = 0 TO 3
      gGrid(x, y) = 0
    NEXT y
  NEXT x

  addblock
  addblock

END SUB

SUB moveBlock (sourceX, sourceY, targetX, targetY, merge)

  IF sourceX < 0 OR sourceX >= gGridSize OR sourceY < 0 OR sourceY >= gGridSize AND gDebug = 1 THEN
    LOCATE 0, 0
    PRINT "moveBlock: source coords out of bounds"
  END IF

  IF targetX < 0 OR targetX >= gGridSize OR targetY < 0 OR targetY >= gGridSize AND gDebug = 1 THEN
    LOCATE 0, 0
    PRINT "moveBlock: source coords out of bounds"
  END IF

  sourceSquareValue = gGrid(sourceX, sourceY)
  targetSquareValue = gGrid(targetX, targetY)

  IF merge = 1 THEN

    IF sourceSquareValue = targetSquareValue THEN
      gGrid(sourceX, sourceY) = 0
      gGrid(targetX, targetY) = targetSquareValue * 2
      gScore = gScore + targetSquareValue * 2 ' Points!
    ELSEIF gDebug = 1 THEN
      LOCATE 0, 0
      PRINT "moveBlock: Attempted to merge unequal sqs"
    END IF

  ELSE

    IF targetSquareValue = 0 THEN
      gGrid(sourceX, sourceY) = 0
      gGrid(targetX, targetY) = sourceSquareValue
    ELSEIF gDebug = 1 THEN
      LOCATE 0, 0
      PRINT "moveBlock: Attempted to move to non-empty block"
    END IF

  END IF

END SUB

FUNCTION pad$ (num)
  strNum$ = LTRIM$(STR$(num))

  SELECT CASE LEN(strNum$)
    CASE 1: pad = "  " + strNum$ + " "
    CASE 2: pad = " " + strNum$ + " "
    CASE 3: pad = " " + strNum$
    CASE 4: pad = strNum$
  END SELECT

END FUNCTION

FUNCTION pColor (r, g, b)
  pColor = (r + g * 256 + b * 65536)
END FUNCTION

SUB processMove (dir AS STRING)
  ' dir can be 'l', 'r', 'u', or 'd'

  hasMoved = 0

  IF dir = "l" THEN

    FOR y = 0 TO gGridSize - 1
      wasMerge = 0
      FOR x = 0 TO gGridSize - 1
        GOSUB processBlock
      NEXT x
    NEXT y

  ELSEIF dir = "r" THEN

    FOR y = 0 TO gGridSize - 1
      wasMerge = 0
      FOR x = gGridSize - 1 TO 0 STEP -1
        GOSUB processBlock
      NEXT x
    NEXT y

  ELSEIF dir = "u" THEN
    FOR x = 0 TO gGridSize - 1
      wasMerge = 0
      FOR y = 0 TO gGridSize - 1
        GOSUB processBlock
      NEXT y
    NEXT x

  ELSEIF dir = "d" THEN
    FOR x = 0 TO gGridSize - 1
      wasMerge = 0
      FOR y = gGridSize - 1 TO 0 STEP -1
        GOSUB processBlock
      NEXT y
    NEXT x

  END IF

  GOTO processMoveEnd

moveToObstacle:
    curX = x
    curY = y

    DO WHILE getAdjacentCell(curX, curY, dir) = 0
      SELECT CASE dir
        CASE "l": curX = curX - 1
        CASE "r": curX = curX + 1
        CASE "u": curY = curY - 1
        CASE "d": curY = curY + 1
      END SELECT
    LOOP
  RETURN

processBlock:

    merge = 0
    IF gGrid(x, y) <> 0 THEN ' have block

      GOSUB moveToObstacle ' figure out where it can be moved to
      IF getAdjacentCell(curX, curY, dir) = gGrid(x, y) AND wasMerge = 0 THEN  ' obstacle can be merged with
        merge = 1
        wasMerge = 1
      ELSE
        wasMerge = 0
      END IF

      IF curX <> x OR curY <> y OR merge = 1 THEN
        mergeDirX = 0
        mergeDirY = 0
        IF merge = 1 THEN
          SELECT CASE dir
            CASE "l": mergeDirX = -1
            CASE "r": mergeDirX = 1
            CASE "u": mergeDirY = -1
            CASE "d": mergeDirY = 1
          END SELECT
        END IF

        CALL moveBlock(x, y, curX + mergeDirX, curY + mergeDirY, merge) ' move to before obstacle or merge
        hasMoved = 1
      END IF
    END IF
  RETURN

processMoveEnd:

  IF hasMoved = 1 THEN addblock
  renderGrid
  updateScore

END SUB

SUB renderGrid
  FOR x = 0 TO gGridSize - 1
    FOR y = 0 TO gGridSize - 1
      CALL drawNumber(gGrid(x, y), x, y)
    NEXT y
  NEXT x
END SUB

SUB updateScore
  LOCATE 1, 10
  PRINT "Score:" + STR$(gScore)
END SUB
