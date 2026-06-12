/* agent.wren */

import "random" for Random
import "./ifc" for Ifc, Log
import "./str" for Char

// The agent's awareness is quite limited.  It has no representation of the
// maze, which direction it is facing, or what it did last.  It notices and
// remembers just three things:  The color of the sector just entered, the
// presence and color of any ball there, and the presence and color of any
// ball it is holding.
var sectorColor = " "
var sectorBall  = " "
var agentBall   = " "
var stream      = null
var noColor     = "-"

var rand = Random.new()

// Move moves one sector in a random direction.
// It retries on bumps and doesn't return until a forward command succeeds.
// It expects a color event on a successful move and terminates if it doesn't
// get one.
var move = Fn.new {
    while (true) {
        // Randomness:  50/50 chance of turning or attempting move.
        // For turns, equal chance of turning right or left.
        var t = rand.int(4)
        if (t == 0) {
            stream.send(Ifc.cmdLeft)
            Fiber.yield()
            while (stream.rec() != Ifc.evStop) { Fiber.yield() }
            continue
        } else if (t == 1) {
            stream.send(Ifc.cmdRight)
            Fiber.yield()
            while (stream.rec() != Ifc.evStop) { Fiber.yield() }
            continue
        }
        stream.send(Ifc.cmdForward)
        var bump = false
        sectorColor = noColor
        sectorBall = noColor
        while (true) {
            Fiber.yield()
            var ev = stream.rec()
            if (ev == Ifc.evBump) {
                bump = true
            } else if ([Ifc.evColorRed, Ifc.evColorGreen, Ifc.evColorYellow, Ifc.evColorBlue].contains(ev)) {
                sectorColor = ev
            } else if ([Ifc.evBallRed, Ifc.evBallGreen, Ifc.evBallYellow, Ifc.evBallBlue].contains(ev)) {
                sectorBall = ev
            } else if (ev == Ifc.evStop) {
                break
            }
        }
        if (bump) continue
        if (sectorColor == noColor) Log.fatal("agent: expected color event after move")
        return
    }
}

// Get is only called when get is possible.
var get = Fn.new {
    stream.send(Ifc.cmdGet)
    while (true) {
        Fiber.yield()
        var ch = stream.rec()
        if (ch == Ifc.evStop) {
            // agent notes ball color, and that sector is now empty
            agentBall = sectorBall
            sectorBall = noColor
            return
        } else if (ch == Ifc.evNoBallInSector || ch == Ifc.evAgentFull) {
            Log.fatal("agent:expected get to succeed")
        }
    }
}

// FindMatching is only called when agent has a ball.
// FindMatching finds a sector where the color matches the ball the agent
// is holding and which does not already contain a matching ball.
// It does not necessarily find an empty matching sector.
var findMatching = Fn.new {
    while (Char.lower(sectorColor) != agentBall || agentBall == sectorBall) move.call()
}

// FindMisplaced wanders the maze looking for a ball on the wrong sector.
var findMisplaced = Fn.new {
    while (true) {
        move.call()

        // get ball from current sector if meaningful
        if ([Ifc.evBallRed, Ifc.evBallGreen, Ifc.evBallYellow, Ifc.evBallBlue].contains(sectorBall)) {
            if (sectorBall != Char.lower(sectorColor)) return
        }
    }
}

// Drop is only called when the agent has a ball.  Unlike get() however,
// drop() can be called whether the sector is empty or not.  drop() means
// drop as soon as possible, so if the sector is full, drop() will wander
// at random looking for an empty sector.
var drop = Fn.new {
    var gameOver = false
    while (sectorBall != noColor) move.call()

    // expected to work
    stream.send(Ifc.cmdDrop)
    while(true) {
        Fiber.yield()
        var ch = stream.rec()
        if (ch == Ifc.evGameOver) {
            gameOver = true
        } else if (ch == Ifc.evStop) {
            break
        } else if (ch == Ifc.evNoBallInAgent || ch == Ifc.evSectorFull) {
            Log.fatal("expected drop to succeed")
        }
    }
    sectorBall = agentBall
    agentBall = noColor
    return gameOver
}

var Agent = Fn.new { |s|
    stream = s

    // handshake
    var hs = stream.rec()
    if (hs != Ifc.handshake) Log.fatal("agent: that's no handshake")
    stream.send(Ifc.handshake)
    Fiber.yield()

    // agent behavior main loop
    var gameOver = false
    while (!gameOver) {
        findMisplaced.call()
        get.call()
        findMatching.call()
        gameOver = drop.call()
    }
}
