/* world.wren */

import "./ifc" for Ifc, Log
import "./str" for Char
import "./fmt" for Fmt
import "./seq" for Lst

// Maze sectors are 3x3 characters, with these quirks:
// String starts with a newline.
// Space at end of each line except the last.
// No space, newline, or blank lines following last W.
//
// In each sector, W or sector Color is mandatory.  If sector has ball,
// it is in the character to the right.  If agent is in a sector, it is in
// the character below and shown by its direction symbol.  If agent has a ball,
// it is in the character to the right.
//
// The variable maze is not just input, but is the primary representation
// of the world.  Over the course of execution, walls and sector colors
// are constant; agent and balls can move.
var maze = """

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
WWWWWWWWWWWWWWWW
""".toList

var stream   = null
var rowLen   = 0
var agentPos = -1

var dirString = "^>v<"
var directions = dirString.toList

var rightOf = Fn.new { |dir| directions[(dirString.indexOf(dir) + 1) % 4] }
var leftOf  = Fn.new { |dir| directions[(dirString.indexOf(dir) + 3) % 4] }

var right = Fn.new { maze[agentPos] = rightOf.call(maze[agentPos]) }
var left  = Fn.new { maze[agentPos] = leftOf.call(maze[agentPos])  }

var get = Fn.new {
    var agentBall = agentPos + 1
    var sectorBall = agentBall - rowLen
    var can = true
    if (maze[sectorBall] == " ") {
        stream.send(Ifc.evNoBallInSector)
        can = false
        Fiber.yield()
    }
    if (maze[agentBall] != " ") {
        stream.send(Ifc.evAgentFull)
        can = false
        Fiber.yield()
    }
    if (can) {
        maze[agentBall] = maze[sectorBall]
        maze[sectorBall] = " "
    }
}

// Win tests for a win state indicating game over.
var win = Fn.new {
    var ballPos = 2
    while (ballPos < maze.count) {
        var ballColor = maze[ballPos]
        if ([Ifc.evBallRed, Ifc.evBallGreen, Ifc.evBallYellow, Ifc.evBallBlue].contains(ballColor)) {
            if (ballColor != Char.lower(maze[ballPos-1])) return false
        }
        ballPos = ballPos + 3
        if (ballPos % rowLen == 1) ballPos = ballPos + 2 * rowLen
    }
    return true
}

var drop = Fn.new {
    var agentBall = agentPos + 1
    var sectorBall = agentBall - rowLen
    var can = true
    if (maze[agentBall] == " ") {
        stream.send(Ifc.evNoBallInAgent)
        can = false
        Fiber.yield()
    }
    if (maze[sectorBall] != " ") {
        stream.send(Ifc.evSectorFull)
        can = false
        Fiber.yield()
    }
    if (can) {
        maze[sectorBall] = maze[agentBall]
        maze[agentBall] = " "
    }
    if (win.call()) {
        stream.send(Ifc.evGameOver)
        Fiber.yield()
        return true
    }
    return false
}

var logTime = Fn.new { |t| Log.prefix = t }

var forward = Fn.new {
    var sectorOrigin = agentPos - rowLen
    var ch = maze[agentPos]
    sectorOrigin = (ch == "^") ? sectorOrigin - 3 * rowLen :
                   (ch == "v") ? sectorOrigin + 3 * rowLen :
                   (ch == "<") ? sectorOrigin - 3 :
                   (ch == ">") ? sectorOrigin + 3 : sectorOrigin
    if (maze[sectorOrigin] == "W") {
        stream.send(Ifc.evBump)
        Fiber.yield()
        // bump event consumes no time
        return 0
    }

    // move agent, plus any ball it has.
    var newPos = sectorOrigin + rowLen
    maze[newPos] = maze[agentPos]
    maze[newPos+1] = maze[agentPos+1]
    maze[agentPos] = " "
    maze[agentPos+1] = " "
    agentPos = newPos

    // send color event for new sector
    stream.send(maze[sectorOrigin])
    Fiber.yield()
    var ball = maze[sectorOrigin+1]
    if (ball != " ") {
        // send ball event
        stream.send(maze[sectorOrigin+1])
        Fiber.yield()
    }
    // for all events except bump, time consumed is 1.
    return 1
}

// Process a single command.
var process = Fn.new { |cmd|
    // timeConsumed is 1, unless the forward function says otherwise.
    var gameOver = false
    var timeConsumed = 1
    if (cmd == Ifc.cmdForward) {
        timeConsumed = forward.call()
    } else if (cmd == Ifc.cmdRight) {
        right.call()
    } else if (cmd == Ifc.cmdLeft) {
        left.call()
    } else if (cmd == Ifc.cmdGet) {
        get.call()
    } else if (cmd == Ifc.cmdDrop) {
        // game over only detected by drop command
        gameOver = drop.call()
    }
    // for all commands, send stop event after all other processing is complete
    stream.send(Ifc.evStop)
    Fiber.yield()
    return [gameOver, timeConsumed]
}

var World = Fn.new { |s|
    stream = s
    rowLen = maze[1..-1].indexOf("\n") + 1
    var cols = (rowLen/3).floor
    var rows = ((((maze.count + 1)/rowLen).floor + 2)/3).floor
    if (maze.count != (rows*3 - 2) * cols * 3 - 1) Log.fatal("mis-shaped maze")
    agentPos = Lst.indexOfAny(maze, directions)
    if (agentPos == -1) Log.fatal("agent not in maze")

    // initialize quantized time as specified
    var time = 0
    logTime.call(time)

    // handshake as specified
    stream.send(Ifc.handshake)
    Fiber.yield()
    var hs = stream.rec()
    if (hs != Ifc.handshake) Log.fatal("world: that's no handshake.")

    // log initial configuration of maze
    Log.print(maze.join())

    // top level world simulation loop
    var gameOver = false
    var timeConsumed = 0
    while (!gameOver) {
        Fiber.yield()
        var res = process.call(stream.rec())
        gameOver = res[0]
        timeConsumed = res[1]
        time = time + timeConsumed
        logTime.call(time)
        Log.print(maze.join())
    }
}
