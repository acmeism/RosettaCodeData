load "guilib.ring"

# --- Configuration Values ---
nRows     = 9       # Number of rows of obstacles
nChannels = 10      # Number of collecting channels (nRows + 1)
nRadius   = 4       # Radius of the obstacles and balls

# Statistics array to count balls in each channel
aChannels = list(nChannels)
for i = 1 to nChannels { aChannels[i] = 0 }

# --- Animation State Variables ---
nBallsLeft   = 0    # Number of remaining balls to release
nCurrentRow  = 0    # Current row index of the moving ball
nRightTurns  = 0    # Number of right turns for the current ball
nBallX       = 250  # Current visual X coordinate of the ball
nBallY       = 70   # Current visual Y coordinate of the ball
nTargetX     = 250  # Target X coordinate for the current step
nTargetY     = 70   # Target Y coordinate for the current step
lMoving      = false # Flag checking if a ball is currently falling

# Fixed rendering parameters
nStartY  = 100
nYStep   = 35
nXStep   = 30

# --- Graphical Window and UI Setup ---
new qApp {
    win = new qWidget() {
        setwindowtitle("Smoothly Animated Galton Board - Ring")
        setgeometry(100, 100, 500, 600)

        # Create a label to serve as the drawing canvas
        canvas = new qLabel(win) {
            setgeometry(0, 0, 500, 600)
        }

        # Button to trigger the animated simulation
        new qPushButton(win) {
            setgeometry(20, 20, 150, 30)
            settext("Launch 100 Balls")
            setclickevent("StartSimulation()")
        }

        # Timer to drive the animation cycle (15 ms for smooth movement)
        oTimer = new qTimer(win) {
            setinterval(15)
            settimeoutevent("AnimateBall()")
        }

        # Render the initial empty board
        DrawBoard()
        show()
    }
    exec()
}

# --- Start Simulation ---
func StartSimulation
    if nBallsLeft = 0 and lMoving = false
        nBallsLeft = 100
        ResetBall()
        oTimer.start()
    ok

# --- Reset State for a New Ball ---
func ResetBall
    nCurrentRow = 0
    nRightTurns = 0
    nBallX      = 250
    nBallY      = 70
    nTargetX    = 250
    nTargetY    = 70
    lMoving     = true

# --- Step Animation and Physics Logic ---
func AnimateBall
    # If no active ball is moving but there are remaining balls
    if lMoving = false
        if nBallsLeft > 0
            nBallsLeft = nBallsLeft - 1
            ResetBall()
        else
            oTimer.stop()
            return
        ok
    ok

    # Approach target visual coordinates (interpolation)
    lReachedX = false
    lReachedY = false

    # Horizontal smoothing
    if nBallX < nTargetX
        nBallX = nBallX + 2
        if nBallX > nTargetX { nBallX = nTargetX }
    but nBallX > nTargetX
        nBallX = nBallX - 2
        if nBallX < nTargetX { nBallX = nTargetX }
    else
        lReachedX = true
    ok

    # Vertical smoothing
    if nBallY < nTargetY
        nBallY = nBallY + 4
        if nBallY > nTargetY { nBallY = nTargetY }
    else
        lReachedY = true
    ok

    # If the ball reached its current sub-target, compute the next decision point
    if lReachedX and lReachedY
        if nCurrentRow < nRows
            nCurrentRow = nCurrentRow + 1
            if random(1) = 1
                nRightTurns = nRightTurns + 1
            ok

            # Set new TARGET coordinates
            nStartX = 250 - ((nCurrentRow - 1) * nXStep / 2)
            nTargetX = nStartX + (nRightTurns * nXStep)
            nTargetY = nStartY + (nCurrentRow * nYStep)
        else
            # Reached the bottom level, place ball into the channel histogram
            nFinalChannel = nRightTurns + 1
            aChannels[nFinalChannel] = aChannels[nFinalChannel] + 1
            lMoving = false
        ok
    ok

    # Refresh the screen canvas
    DrawBoard()

# --- Rendering Function (QPainter) ---
func DrawBoard
    p1 = new qPicture()
    penObstacle = new qPen() { setcolor(new qColor() { setrgb(120, 120, 120, 255) }) }
    penBallHist = new qPen() { setcolor(new qColor() { setrgb(230, 50, 50, 255) }) }
    brushBallHist = new qBrush() { setcolor(new qColor() { setrgb(230, 50, 50, 255) }) setstyle(1) }

    # Style for the currently active falling ball (highlighted in Green)
    penActiveBall = new qPen() { setcolor(new qColor() { setrgb(50, 200, 50, 255) }) }
    brushActiveBall = new qBrush() { setcolor(new qColor() { setrgb(50, 200, 50, 255) }) setstyle(1) }

    painter = new qPainter() {
        begin(p1)

        # 1. Draw Pegs/Obstacles in a Triangular Grid
        setpen(penObstacle)
        for row = 1 to nRows
            nStartX = 250 - ((row - 1) * nXStep / 2)
            for col = 1 to row
                nX = nStartX + ((col - 1) * nXStep)
                nY = nStartY + ((row - 1) * nYStep)
                drawEllipse(nX - nRadius, nY - nRadius, nRadius * 2, nRadius * 2)
            next
        next

        # 2. Draw the Currently Active Ball
        if lMoving
            setpen(penActiveBall)
            setbrush(brushActiveBall)
            drawEllipse(nBallX - nRadius, nBallY - nRadius, nRadius * 2, nRadius * 2)
        ok

        # 3. Draw Channels and Accumulated Balls at the Bottom
        setpen(penBallHist)
        setbrush(brushBallHist)

        nBaseY        = 520
        nChannelWidth = 32
        nLeftBoundary = 250 - ((nChannels * nChannelWidth) / 2)

        for c = 1 to nChannels
            nChannelX = nLeftBoundary + ((c - 1) * nChannelWidth)
            drawLine(nChannelX, nBaseY, nChannelX, nBaseY - 60)

            nHeight = aChannels[c] * 6
            if nHeight > 0
                drawRect(nChannelX + 4, nBaseY - nHeight, nChannelWidth - 8, nHeight)
            ok
        next

        # Draw bounding lines and baseline
        drawLine(nLeftBoundary + (nChannels * nChannelWidth), nBaseY, nLeftBoundary + (nChannels * nChannelWidth), nBaseY - 60)
        drawLine(nLeftBoundary, nBaseY, nLeftBoundary + (nChannels * nChannelWidth), nBaseY)

        endpaint()
    }
    canvas.setpicture(p1)
