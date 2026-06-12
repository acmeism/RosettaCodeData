package world

import (
    "bytes"
    "fmt"
    "log"

    "ra/ifc"
)

// Maze sectors are 3x3 bytes, with these quirks:
// String starts with a newline.
// Space at end of each line except the last.
// No space, newline, or blank lines following last W.
//
// In each sector, W or sector Color is mandantory.  If sector has ball,
// it is in the byte to the right.  If agent is in a sector, it is in
// the byte below and shown by its direction symbol.  If agent has a ball,
// it is in the byte to the right.
//
// The variable maze is not just input, but is the primary representation
// of the world.  Over the course of execution, walls and sector colors
// are constant; agent and balls can move.

/* Minimal layout looks like this:
var maze = []byte(`
W  W  W  W  W  W


W  Rb W  Rg B  W


W  G  G  B  G  W


W  Br G  W  R  W
            ^

W  W  W  W  W  W`)
*/

// Following is equivalent, but with walls a little easier to see:
var maze = []byte(`
WWWWWWWWWWWWWWWW
W     W        W
W     W        W
W  Rb W  Rg B  W
W              W
W              W
W  G  G  B  G  W
W              W
W              W
W  Br G  W  R  W
W        W  ^  W
W        W     W
WWWWWWWWWWWWWWWW`)

// Maze and the following variables are defined at package level
// just to simplify function calls.
var (
    stream   ifc.Streamer
    rowLen   int
    agentPos int
)

// Directions are not part of the interface, but just something the
// world uses to keep track of the orientation of the agent.
// A little quirk of bytes.IndexAny is that it takes a string.
// Otherwise, the []byte version is more useful for bytes.IndexByte.
const dirString = "^>v<"

var directions = []byte(dirString)

func rightOf(dir byte) byte {
    return directions[(bytes.IndexByte(directions, dir)+1)%4]
}

func leftOf(dir byte) byte {
    return directions[(bytes.IndexByte(directions, dir)+3)%4]
}

func World(s ifc.Streamer) {
    stream = s
    rowLen = bytes.Index(maze[1:], []byte{'\n'}) + 1
    // A couple of validations for things I thought might be easy to
    // mess up when editing the maze or defining a new one.
    // Additional maze validation could be added.
    cols := rowLen / 3
    rows := ((len(maze)+1)/rowLen + 2) / 3
    if len(maze) != (rows*3-2)*cols*3-1 {
        log.Fatal("mis-shaped maze")
    }
    agentPos = bytes.IndexAny(maze, dirString)
    if agentPos < 0 {
        log.Fatal("agent not in maze")
    }
    // initialize quantized time as specified
    time := 0
    logTime(time)
    // handshake as specified
    stream.Send(ifc.Handshake)
    hs := stream.Rec()
    if hs != ifc.Handshake {
        log.Fatal("world: thats no handshake.")
    }
    // log initial configuration of maze
    log.Print(string(maze))
    // top level world simulation loop
    gameOver := false
    timeConsumed := 0
    for !gameOver {
        gameOver, timeConsumed = process(stream.Rec())
        time += timeConsumed
        logTime(time)
        log.Print(string(maze))
    }
}

// logTime sets the log prefix to the current quantized time value.
// It does not actually log anything.
func logTime(t int) {
    log.SetPrefix(fmt.Sprintf("%06d: ", t))
}

// Process a single command.
func process(cmd byte) (gameOver bool, timeConsumed int) {
    // timeConsumed is 1, unless the forward function says otherwise.
    timeConsumed = 1
    switch cmd {
    case ifc.CmdForward:
        timeConsumed = forward()
    case ifc.CmdRight:
        right()
    case ifc.CmdLeft:
        left()
    case ifc.CmdGet:
        get()
    case ifc.CmdDrop:
        // game over only detected by drop command
        gameOver = drop()
    }
    // for all commands, send stop event after all other processing is complete
    stream.Send(ifc.EvStop)
    return
}

func forward() (timeConsumed int) {
    sectorOrigin := agentPos - rowLen
    switch maze[agentPos] {
    case '^':
        sectorOrigin -= 3 * rowLen
    case 'v':
        sectorOrigin += 3 * rowLen
    case '<':
        sectorOrigin -= 3
    case '>':
        sectorOrigin += 3
    }
    if maze[sectorOrigin] == 'W' {
        stream.Send(ifc.EvBump)
        // bump event consumes no time
        return 0
    }
    // move agent, plus any ball it has.
    newPos := sectorOrigin + rowLen
    maze[newPos] = maze[agentPos]
    maze[newPos+1] = maze[agentPos+1]
    maze[agentPos] = ' '
    maze[agentPos+1] = ' '
    agentPos = newPos
    // send color event for new sector
    stream.Send(maze[sectorOrigin])
    if ball := maze[sectorOrigin+1]; ball != ' ' {
        // send ball event
        stream.Send(maze[sectorOrigin+1])
    }
    // for all events except bump, time consumed is 1.
    return 1
}

func right() {
    maze[agentPos] = rightOf(maze[agentPos])
}

func left() {
    maze[agentPos] = leftOf(maze[agentPos])
}

func get() {
    agentBall := agentPos + 1
    sectorBall := agentBall - rowLen
    can := true
    if maze[sectorBall] == ' ' {
        stream.Send(ifc.EvNoBallInSector)
        can = false
    }
    if maze[agentBall] != ' ' {
        stream.Send(ifc.EvAgentFull)
        can = false
    }
    if can {
        maze[agentBall] = maze[sectorBall]
        maze[sectorBall] = ' '
    }
}

func drop() (gameOver bool) {
    agentBall := agentPos + 1
    sectorBall := agentBall - rowLen
    can := true
    if maze[agentBall] == ' ' {
        stream.Send(ifc.EvNoBallInAgent)
        can = false
    }
    if maze[sectorBall] != ' ' {
        stream.Send(ifc.EvSectorFull)
        can = false
    }
    if can {
        maze[sectorBall] = maze[agentBall]
        maze[agentBall] = ' '
    }
    if win() {
        stream.Send(ifc.EvGameOver)
        return true
    }
    return false
}

// Win tests for a win state indicating game over.  A more efficient technique
// might be to track the number of balls out of place and recognize immediately
// when the last ball was dropped on a matching sector, but this technique
// is simple and robust.
func win() bool {
    ballPos := 2
    for ballPos < len(maze) {
        switch ballColor := maze[ballPos]; ballColor {
        case ifc.EvBallRed, ifc.EvBallGreen, ifc.EvBallYellow, ifc.EvBallBlue:
            if ballColor != maze[ballPos-1]+32 {
                return false
            }
        }
        ballPos += 3
        if ballPos%rowLen == 1 {
            ballPos += 2 * rowLen
        }
    }
    return true
}
